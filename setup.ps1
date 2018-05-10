#gets netbios domain name and admin credentials to join to domain
$domain = Read-Host -Prompt 'NETBIOS domain name'
$adminCredcential = Get-Credential 

#Module containing some predefined functions to keep this simpler
Import-Module Module.psm1

#Installs MS Office 2016 with a preset configuration and license key.
#The complete installation not included with github repo, as that is licensed through my current employer
Write-Output "Installing MS Office 2016"
Start-Process -FilePath C:\Install\64\setup.exe -ArgumentList "/adminfile setup20161013-2.MSP" -Wait

#This runs through the command line version of Ninite Pro. Not included with my github repo, as that is licensed through my current employer
Write-Output "Running Ninite"
Start-Process -FilePath C:\Install\NinitePro\NinitePro.exe -ArgumentList "/silent NiniteReport.txt /select Flash `"Google Backup and Sync`" `"7-Zip`" Chrome CutePDF Reader VLC Silverlight Pidgin Air Shockwave /allusers" -Wait
Write-Output "Running Ninite updates"
Start-Process C:\Install\NinitePro\NinitePro.exe -ArgumentList "/silent /updateonly NinireUpdateReport.txt" -Wait

#desktopinfo shows system data in the bottom right corner
#with the included config, hostname, free space, signed in user, memory are the main details shown
Write-Output "Setting up DesktopInfo"
Copy-Item 'C:\Install\SMCH Info' -Destination 'C:\SMCH Info'

#All of the shortcuts being deleted here are ones that nobody really opens by themselves, but rather through parent programs or
#through file type associations.
Write-Output "Deleting Useless Shortcuts"
$deleteList = "C:\Users\Public\Desktop\Google Docs.lnk","C:\Users\Public\Desktop\Google Sheets.lnk","C:\Users\Public\Desktop\Google Slides.lnk","C:\Users\Public\Desktop\VLC media player.lnk","C:\Users\Public\Desktop\Acrobat Reader DC.lnk"
$i = 0
foreach($item in $deleteList)
{
    Remove-Item -Path $item
    $i++
    Write-Output "Deleted $i of $deleteList.Count"
}

#Moving the shortcuts from Public to Default allows the users to delete any unwanted shortcuts
Write-Output "Moving shortcuts to default"
Move-Item -Path C:\Users\Public\Desktop\* -Destination C:\Users\Default\Desktop

#pulling the values from wmic, the output is similar to "Model=2w3414125"
#upon splitting on the =, "model" gets put itno the discard, and "2w3414125" into $model
Write-Output "Getting model and serial numbers"
$discard,$model = $(wmic ComputerSystem Get Model /value | Out-String).split('=')
$discard,$serial = $(wmic systemenclosure get serialnumber /value | Out-String).split('=')
Clear-Variable $discard

name-and-others($serial,$model,$domain,$adminCredcential);