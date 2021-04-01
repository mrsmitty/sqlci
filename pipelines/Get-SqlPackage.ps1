
mkdir SqlPackage
Write-Host "Downloading latest version of SQL Package"
$sqlPackageUrl = "https://go.microsoft.com/fwlink/?linkid=2157302"
Invoke-WebRequest -Uri $sqlPackageUrl -OutFile sqlPackage.zip

Write-Host "Unpacking SQL Package"
Expand-Archive sqlPackage.zip -DestinationPath SqlPackage

Write-Host "Adding $(Get-Location)\SqlPackage to Path"
$env:Path += ";$(Get-Location)\SqlPackage" 

Write-Host "removing sqlpackage.zip"
Remove-Item .\sqlPackage.zip