@echo off
echo Installing MS Office 2016
start /wait C:\Install\64\setup.exe /adminfile setup20161013-2.MSP
echo Running Ninite
start /wait C:\Install\NinitePro\NinitePro.exe /silent NiniteReport.txt /select Flash "Google Backup and Sync" "7-Zip" Chrome CutePDF Reader VLC Silverlight Pidgin Air Shockwave /allusers
echo Running Ninite updates
start /wait C:\Install\NinitePro\NinitePro.exe /silent /updateonly NinireUpdateReport.txt
echo Setting up DesktopInfo
xcopy /S /I "C:\Install\SMCH Info" "C:\SMCH Info" /Y
xcopy "C:\SMCH Info\Desktop Info\DesktopInfo.lnk" "%allusersprofile%\Microsoft\Windows\Start Menu\Programs\Startup\" /Y
echo Removing useless desktop shortcuts
del "C:\Users\Public\Desktop\Google Docs.lnk"
echo 1/5 Gone
del "C:\Users\Public\Desktop\Google Sheets.lnk"
echo 2/5 Gone
del "C:\Users\Public\Desktop\Google Slides.lnk"
echo 3/5 Gone
del "C:\Users\Public\Desktop\VLC media player.lnk"
echo 4/5 Gone
del "C:\Users\Public\Desktop\Acrobat Reader DC.lnk"
echo 5/5 Gone
echo Moving shortcuts to default
move C:\Users\Public\Desktop\* C:\Users\Default\Desktop
echo Getting model and serial number
FOR /F "tokens=2 delims='='" %%A in ('wmic ComputerSystem Get Model /value') do SET model=%%A
echo Model:%model%
FOR /F "tokens=2 delims='='" %%B in ('wmic systemenclosure get serialnumber /value') do SET serial=%%B
echo Serial:%serial%
set nameset=0
IF "%model%"=="80LT" (
    echo Is laptop, LT1 , installing SW Agent
    set name=LT1-%serial%
    msiexec /i "C:\Install\Agent\SpiceworksTLSAgent.msi" TRANSFORMS="C:\Install\Agent\customswagent.mst" /q
    echo Adding WiFi
    netsh wlan add profile filename="C:\Install\Wi-Fi-SMCH - Work Devices.xml"
    set nameset=1
)
echo Through LT1
IF "%model%"=="20EV002FUS" (
    echo Is laptop, LT2, installing SW Agent
    set name=LT2-%serial%
    msiexec /i "C:\Install\Agent\SpiceworksTLSAgent.msi" TRANSFORMS="C:\Install\Agent\customswagent.mst" /q
    echo Adding WiFi
    netsh wlan add profile filename="C:\Install\Wi-Fi-SMCH - Work Devices.xml"
    set nameset=1
)
echo Through LT2
IF "%model%"=="10G9000NUS" (
    echo IS desktop, DT1
    set name=DT2-%serial%
    set nameset=1
)
echo Through DT1
IF "%model%"=="10HY0017US" (
    echo IS desktop, DT2
    set name=DT1-%serial%
    set nameset=1
)
echo Through DT2
if "%nameset%"=="0" (
    echo No match
    set name=Uhhh-%model%
)
echo Got through if
echo Renaming to %name%
powershell Set-ExecutionPolicy RemoteSigned
powershell "C:\Install\rename.ps1 %name%"
powershell Set-ExecutionPolicy Restricted
echo Joining to Domain
powershell Set-ExecutionPolicy RemoteSigned
powershell "C:\Install\domainjoin.ps1"
powershell Set-ExecutionPolicy Restricted
start "C:\SMCH Info\Desktop Info\DesktopInfo.exe"
shutdown /r /t 20