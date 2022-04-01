# Script to serch for User profiles on the kiosks and delete them.
# Created By: Daniel Donahay

UserIDFun

# Array list set up
$kiosks = "CAMA-SPROF-D01", "CAMA-SPROF-D02", "CAMA-KSKCF-D01", "CAMA-KSKCR-D01", "CAMA-KSKCR-D02", "CAMA-KSKFB-D01"
$foundProfiles = [System.Collections.ArrayList]::new()

# Header Function
function Headerfun {

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

# Exit script function
function ExitFun {
    Headerfun
    Write-Host "Exiting..." -ForegroundColor Yellow
    Start-Sleep 5
    exit
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













