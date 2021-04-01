mkdir SqlPackage
$sqlPackageUrl = "https://go.microsoft.com/fwlink/?linkid=2157302"
Invoke-WebRequest -Uri $sqlPackageUrl -OutFile sqlPackage.zip
Expand-Archive sqlPackage.zip -DestinationPath SqlPackage
$env:Path += ";$(Get-Location)\SqlPackage" 
Remove-Item .\sqlPackage.zip