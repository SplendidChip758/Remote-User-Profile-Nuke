$test = get-content .\HostNames.json | ConvertFrom-Json

foreach($i in $test.fab.Diff){
    Write-Host $i -ForegroundColor Green
    $name = Get-WmiObject -Class Win32_Userprofile -ComputerName $i | Where-Object {$_.LocalPath -like "C:\Users\*"} | Select-Object -ExpandProperty LocalPath
    foreach($n in $name){
        Write-Host $n
    }
}
