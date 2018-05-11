#This module contains some specific functions that would just make setup.ps1 too long, in my opinion

#sets up some things that are specific to laptops for our work environment
function laptopSpecificSettings{
    #adding our wifi network to the laptop, no you won't find it in the repo
    netsh wlan add profile filename="C:\Install\bin\Wi-Fi-SMCH - Work Devices.xml"
    #this installs our spiceworks agent, you won't find this their either due to secret keys and whatnot
    #For more information on Spiceworks inventory system which this is for, see this
    #https://www.spiceworks.com/free-pc-network-inventory-software/
    msiexec /i "C:\Install\Agent\SpiceworksTLSAgent.msi" TRANSFORMS="C:\Install\bin\Agent\customswagent.mst" /q
}


function nameAndOthers($serial,$model,$domain,$credential){
    $unitName=""
    if($model -eq "80LT"){
        Write-Output "LT1"
        $unitName ="LT1-$serial"
        laptopSpecificSettings
    }ElseIf($model -eq "20EV002FUS"){
        Write-Output "LT2"
        $unitName="LT2-$serial"
        laptopSpecificSettings
    }ElseIf($model -eq "10G9000NUS"){
        Write-Output "DT1"
        $unitName="DT1=$serial"
    }ElseIf($model -eq "10HY0017US"){
        Write-Output "DT2"
        $unitName="DT2-$serial"
    }Else{
        Write-Output "Unknown"
        $unitName="Unknown-$serial"
    }
    #renames the computer
    (Get-WmiObject Win32_ComputerSystem).Rename("$unitName")
    #joins to domain
    Add-Computer -DomainName $domain -Credential $credential
}