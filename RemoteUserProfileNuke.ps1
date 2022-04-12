# Script to serch for User profiles on the kiosks and delete them.
# Requiers Powershell Version 5.1
# Created By: Daniel Donahay

# HostsNmaes import
$hostList = get-content .\HostNames.json | ConvertFrom-Json

$kiosks = $hostList.kiosks
$training = $hostList.training

$photo = $hostList.fab.photo
$etch = $hostList.fab.etch
$thinFilms = $hostList.fab.thinFilms
$diff = $hostList.fab.diff
$epi = $hostList.fab.epi
$fab = $photo + $etch + $thinFilms + $diff + $epi

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
    Write-Host "1. Single Target"
    Write-Host "2. Simple Batch Mode"
    Write-Host "3. Advanced Targeted Search TODO"
    Write-Host "4. Advanced Multi Search TODO"
    Write-Host ""
}

# Simple Mode Menu
function Simple-Menu {
    
    Write-Host "Batch Mode:" -ForegroundColor Green
    Write-Host "1. Kiosks"
    Write-Host "2. Fab Wide"
    Write-Host "3. Photo"
    Write-Host "4. Etch"
    Write-Host "5. ThinFilms"
    Write-Host "6. Diff"
    Write-Host "7. Epi"
    Write-Host "8. Training"
    Write-Host ""
}

function Advanced-Menu {
    
    Write-Host "Advanced Mode:" -ForegroundColor Green
    Write-Host "1. Multi"
    Write-Host "2. Single"
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
            Batch-Mode

        }
        '3'{

        }
        '4'{

        }
        '66' {
            Baggins-Mode

        }
        'q'{
            Exit-Script

        }
    }    
}

function Simple-Mode {

    Header
    
    
}

function Batch-Mode {

    do {

        Header
        Simple-Menu

        $option = $(Write-Host "Select A group to Search (q to Quit): " -ForegroundColor Green -NoNewline; Read-Host)
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
            Search-Hosts (Get-UserID) $photo
        }
        '4' {
            Search-Hosts (Get-UserID) $etch 
        }
        '5' {
            Search-Hosts (Get-UserID) $thinFilms 
        }
        '6' {
            Search-Hosts (Get-UserID) $diff
        }
        '7' {
            Search-Hosts (Get-UserID) $epi
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

function Baggins-mode {

    
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

        

        $input = $(Write-Host "Enter Host To Nuke: " -ForegroundColor Green -NoNewline; Read-Host)

        IF([string]::IsNullOrWhiteSpace($input)) {

            Header
            Write-Host "Hostname is invalid or is disconected"
            pause

        } else {
            
            if((Resolve-DnsName -name $input -ErrorAction SilentlyContinue) -and (Test-Connection -TargetName $input -Quiet)){
                $hostList.Add($input)
            }else {
                Header
                Write-Host "Hostname is invalid or is disconected"   
                pause
            }
        }



        
    
        
    } until ($input -eq "c" -or $input -eq "C" -or $input -eq "confirm")
    

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













