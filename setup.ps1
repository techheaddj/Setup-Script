Write-Output "Installing MS Office 2016"
Start-Process -FilePath C:\Install\64\setup.exe -ArgumentList "/adminfile setup20161013-2.MSP" -Wait
Write-Output "Running Ninite"
Start-Process -FilePath C:\Install\NinitePro\NinitePro.exe -ArgumentList "/silent NiniteReport.txt /select Flash `"Google Backup and Sync`" `"7-Zip`" Chrome CutePDF Reader VLC Silverlight Pidgin Air Shockwave /allusers" -Wait
Write-Output "Running Ninite updates"
Start-Process C:\Install\NinitePro\NinitePro.exe -ArgumentList "/silent /updateonly NinireUpdateReport.txt" -Wait
Write-Output "Setting up DesktopInfo"
Copy-Item 'C:\Install\SMCH Info' -Destination 'C:\SMCH Info'
Write-Output "Deleting Useless Shortcuts"
$deleteList = "C:\Users\Public\Desktop\Google Docs.lnk","C:\Users\Public\Desktop\Google Sheets.lnk","C:\Users\Public\Desktop\Google Slides.lnk","C:\Users\Public\Desktop\VLC media player.lnk","C:\Users\Public\Desktop\Acrobat Reader DC.lnk"
$i = 0

foreach($item in $deleteList)
{
    Remove-Item -Path $item
    $i++
    Write-Output "Deleted $i of $deleteList.Count"
}
Write-Output "Moving shortcuts to default"
Move-Item -Path C:\Users\Public\Desktop\* -Destination C:\Users\Default\Desktop
Write-Output "Getting model and serial numbers"
$discard,$model = $(wmic ComputerSystem Get Model /value | Out-String).split('=')
$discard,$serial = $(wmic systemenclosure get serialnumber /value | Out-String).split('=')
Clear-Variable $discard
