$params = Get-Content ..\params.json | ConvertFrom-Json

$sqlpackagepath = "C:\Program Files\Microsoft SQL Server\150\DAC\bin\SqlPackage.exe"

& $sqlpackagepath /a:Publish /tsn:. /tdn:test /tu:sa /tp:$($params.saPassword) /sf:test.dacpac