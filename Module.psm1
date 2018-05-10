﻿#This module contains some specific functions that would just make setup.ps1 too long, in my opinion

#sets up some things that are specific to laptops for our work environment
function laptop-specific-settings{
    #adding our wifi network to the laptop, no you won't find it in the repo
    netsh wlan add profile filename="C:\Install\Wi-Fi-SMCH - Work Devices.xml"
    #this installs our spiceworks agent, you won't find this their either due to secret keys and whatnot
    #For more information on Spiceworks inventory system which this is for, see this
    #https://www.spiceworks.com/free-pc-network-inventory-software/
    msiexec /i "C:\Install\Agent\SpiceworksTLSAgent.msi" TRANSFORMS="C:\Install\Agent\customswagent.mst" /q
}


function name-and-others($serial,$model,$domain,$credential){
    $unitName=""
    if($model="80LT"){
        Write-Output "LT1"
        $unitName ="LT1-$serial"
        laptop-specific-settings();
    }ElseIf($model="20EV002FUS"){
        Write-Output "LT2"
        $unitName="LT2-$serial"
        laptop-specific-settings();
    }ElseIf($model="10G9000NUS"){
        Write-Output "DT1"
        $unitName="DT1=$serial"
    }ElseIf($model="10HY0017US"){
        Write-Output "DT2"
        $unitName="DT2-$serial"
    }Else{
        Write-Output "Unknown"
        $unitName="Unknown-$serial"
    }
    (Get-WmiObject Win32_ComputerSystem).Rename("$unitName")
    Add-Computer -DomainName $domain -Credential $credential
}