# Powershell module to search for User profiles on the kiosks and delete them.
# Requiers Powershell Version 5.1
# Created By: Daniel Donahay

function Verb-Noun {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="UserNames",
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="TODO")]
        [Alias("Users")]
        [ValidateNotNullOrEmpty()]
        [array[]]
        $UserNames,

        [Parameter(Mandatory=$true,
                   Position=1,
                   ParameterSetName="HostNames",
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="TODO")]
        [Alias("Hosts")]
        [ValidateNotNullOrEmpty()]
        [array[]]
        $HostNames
    )
    
    begin {
        Write-Host "begin"
    }
    
    process {
        Write-Host $HostNames
        Write-Host $UserNames
        
    }
    
    end {
        Write-Host "end"
    }
}