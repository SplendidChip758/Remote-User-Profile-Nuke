# Script to serch for User profiles on the kiosks and delete them.
# Created By: Daniel Donahay

# Hosts arrays
$kiosks = "CAMA-SPROF-D01", "CAMA-SPROF-D02", "CAMA-KSKCF-D01", "CAMA-KSKCR-D01", "CAMA-KSKCR-D02", "CAMA-KSKFB-D01"
$fab = " "

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

    Write-Host "Menu:"

    Write-Host "1. Simple Batch Mode"
    Write-Host "2. Advanced Targeted Host Mode"
    Write-Host "3. Comming soon"
    Write-Host
}

# Simple Mode Menu
function Simple-Menu {
    
    Write-Host "Simple Mode Options:"

    
}

# Exit script function
function Exit {
    Headerfun
    Write-Host "Exiting..." -ForegroundColor Yellow
    Start-Sleep 5
    exit
}

function Start-Script {

    do {

        Header
        Main-Menu

        $option = $(Write-Host "Select An option (q to Quit): " -ForegroundColor Green -NoNewline; Read-Host)

    } until ($option -eq 'q')

    switch ($option) {
        '1' {
            Write-Host "hello there"
            Simple-Mode
            pause
                
        }
        '2' {

        }
        '66' {

        }
        'q'{

        }
    }    
}

function Simple-Mode {

    Header
    Simple-Menu
    

    
}

function UserIDFun {

    Headerfun
    
    $userID = $(Write-Host "Enter User ID To Nuke: " -ForegroundColor Green -NoNewline; Read-Host)
    $hostNames = $(Write-Host " Enter Hosts to search: " -ForegroundColor Green -NoNewline; Read-Host)

    SearchHosts $userID $hostNames

}

function SearchHosts($userID, $hostNames) {

    Headerfun

    Write-Host "Serching for" $userID "on Kiosks." -ForegroundColor Green

    # For loop to search all 6 Kiosks and add the results to a List
    foreach ($computerName in $hostNames){
        $f = Get-WmiObject -ComputerName $computerName -class Win32_Userprofile | Where-Object {$_.LocalPath -eq 'C:\Users\'+$userID} | Select-Object -ExpandProperty __Server
        IF([string]::IsNullOrWhiteSpace($f)) {            
                    
        } else {            
            $foundProfiles.Add($f) | Out-Null 
            (Write-Host "Found profile on " -NoNewline) + (Write-Host $f -ForegroundColor Red)       
        }  
        
    }

    # Check if profiles were found
    if ($foundProfiles.Count -eq 0){
        Clear-Host
        HeaderFun
        Write-Host "No profiles were found for" $userID
        Start-Sleep 5
        ExitFun

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













