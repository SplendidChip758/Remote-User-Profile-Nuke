# Script to serch for User profiles on the kiosks and delete them.
# Created By: Daniel Donahay

# Hosts arrays
$kiosks = "CAMA-SPROF-D01", "CAMA-SPROF-D02", "CAMA-KSKCF-D01", "CAMA-KSKCR-D01", "CAMA-KSKCR-D02", "CAMA-KSKFB-D01"
$fab = " "

# Hosts to search array init
$hostList =[System.Collections.ArrayList]::new()

# user profile serch reslts array init
$foundProfiles = [System.Collections.ArrayList]::new()

#Script Start
Start-Script

# Header Function
function Header {

    Clear-Host

    Write-Host "-----------------------------------------------------------------------------------------------------------"
    Write-Host " _   _                ______           __ _ _        _____      _     _ _        _   _   _       _         "
    Write-Host "| | | |               | ___ \         / _(_) |      |  _  |    | |   (_) |      | | | \ | |     | |        "
    Write-Host "| | | |___  ___ _ __  | |_/ / __ ___ | |_ _| | ___  | | | |_ __| |__  _| |_ __ _| | |  \| |_   _| | _____  "
    Write-Host "| | | / __|/ _ \ '__| |  __/ '__/ _ \|  _| | |/ _ \ | | | | '__| '_ \| | __/ _  | | | .   | | | | |/ / _ \ "
    Write-Host "| |_| \__ \  __/ |    | |  | | | (_) | | | | |  __/ \ \_/ / |  | |_) | | || (_| | | | |\  | |_| |   <  __/ "
    Write-Host " \___/|___/\___|_|    \_|  |_|  \___/|_| |_|_|\___|  \___/|_|  |_.__/|_|\__\__,_|_| \_| \_/\__,_|_|\_\___| "
    Write-Host "-----------------------------------------------------------------------------------------------------------"
    Write-Host ""
}

# Main Menu
function Main-Menu {

    Write-Host "Menu:" -ForegroundColor Green
    Write-Host "1. Simple Batch Mode"
    Write-Host "2. Advanced Targeted Host Mode"
    Write-Host "3. Comming soon"
    Write-Host ""
}

# Simple Mode Menu
function Simple-Menu {
    
    Write-Host "Simple Mode:" -ForegroundColor Green
    Write-Host "1. Kiosks"
    Write-Host "2. Fab"
    Write-Host "3. Custom"
    Write-Host ""
}

function Advanced-Menu {
    
    Write-Host "Advanced Mode:" -ForegroundColor Green
    Write-Host "1. multi"
    Write-Host "2. single"
    Write-Host "3. Custom"
    Write-Host ""
}

# Exit script function
function Exit-Script {
    Header
    Write-Host "Exiting..." -ForegroundColor Yellow
    Start-Sleep 5
    exit
}

function Start-Script {

    do {

        Header
        Main-Menu

        $option = $(Write-Host "Select An option (q to Quit): " -ForegroundColor Green -NoNewline; Read-Host)

    } until ($option -eq '1' -or $option -eq '2' -or $option -eq '66' -or $option -eq 'q')

    switch ($option) {
        '1' {           
            Simple-Mode               
        }
        '2' {
            Advanced-Mode

        }
        '66' {
            Get-Baggins

        }
        'q'{
            Exit-Script

        }
    }    
}

function Simple-Mode {

    do {

        Header
        Simple-Menu

        $option = $(Write-Host "Select A group to scan (q to Quit): " -ForegroundColor Green -NoNewline; Read-Host)
        Write-Host $kiosks

    } until ($option -eq '1' -or $option -eq '2' -or $option -eq '3' -or $option -eq 'q')

    switch ($option) {
        '1' {
            Search-Hosts (Get-UserID) $kiosks 
        }
        '2' {
            Search-Hosts (Get-UserID) $fab
        }
        '3' {

        }
        'q'{
            Exit-Script
        }
    }       
}

function Advanced-Mode {

    do {

        Header
        Advanced-Menu

        $option = $(Write-Host "Select An option (q to Quit): " -ForegroundColor Green -NoNewline; Read-Host)

    } until ($option -eq '1' -or $option -eq '2' -or $option -eq '3' -or $option -eq 'q')

    switch ($option) {
        '1' {
            Search-Hosts (Get-UserID) (Get-Hosts)
        }
        '2' {

        }
        '3' {

        }
        'q'{
            Exit-Script

        }
    }       
}

function Get-Baggins {

    
}

function Get-UserID {

    Header
    
    $userID = $(Write-Host "Enter User IDs To Nuke: " -ForegroundColor Green -NoNewline; Read-Host)

    return $userID

}

function Get-Hosts {

    do {

        Header

        Write-Host ""
        Write-Host "Hosts: " $hostList 
        Write-Host

        do {

            Header

            $hosts = $(Write-Host "Enter Host To Nuke: " -ForegroundColor Green -NoNewline; Read-Host)

            IF([string]::IsNullOrWhiteSpace($hosts)) {

                Resolve-DnsName -name $hosts -ErrorAction SilentlyContinue | Select-Object 

                if($?){
                    $valid = $True
                }else {
                    Header
                    Write-Host "Hostname is invalid or is disconected"
                
                }
            } else {
                Header
                    Write-Host "Hostname is invalid or is disconected"
            }



        } until ($valid -eq $True)

        $hostList.Add($hosts)
    
        
    } until ($option -eq "c" -or $option -eq "C" -or $option -eq "confirm")
    

    return $hostList
    
    
    
}

function Search-Hosts($userID, $hosts) {

    Header

    Write-Host "Serching for" $userID "on" $hosts  -ForegroundColor Green

    # For loop to search all 6 Kiosks and add the results to a List
    foreach ($computerName in $hosts){
        $f = Get-WmiObject -ComputerName $computerName -class Win32_Userprofile | Where-Object {$_.LocalPath -eq 'C:\Users\'+$userID} | Select-Object -ExpandProperty __Server
        IF([string]::IsNullOrWhiteSpace($f)) {            
                    
        } else {            
            $foundProfiles.Add($f) | Out-Null 
            (Write-Host "Found profile on " -NoNewline) + (Write-Host $f -ForegroundColor Red)       
        }  
        
    }

    # Check if profiles were found
    if ($foundProfiles.Count -eq 0){
        
        Header
        Write-Host "No profiles were found for" $userID
        Start-Sleep 5
        Exit-Script

    } else {
        $yn = $(Write-Host "Would you like to Delete the found Profiles [y,n]: " -ForegroundColor Green -NoNewline; Read-Host)

        if ($yn -eq "y") {

            DeleteFoundprofiles $foundProfiles

        } else {
            ExitFun
        }
    }
    
}

function DeleteFoundprofiles($foundProfiles) {

    Headerfun
    
    foreach ($computerName in $foundProfiles){

        Get-WmiObject -ComputerName $computerName -class Win32_Userprofile | Where-Object {$_.LocalPath -eq 'C:\Users\'+$userID} | Remove-WmiObject
    }
    
}













