
[CmdletBinding()]
param (
    [Parameter()] [string] $sqlPackageZip
)

mkdir SqlPackage
if (-Not (Test-Path sqlPackageZip)) {
    Write-Host "Downloading latest version of SQL Package"
    $sqlPackageUrl = "https://go.microsoft.com/fwlink/?linkid=2157302"
    Invoke-WebRequest -Uri $sqlPackageUrl -OutFile sqlPackage.zip
} else {
    Copy-Item $sqlPackageZip "$(Get-Location)\sqlpackage.zip"
}

Write-Host "Unpacking SQL Package"
Expand-Archive sqlPackage.zip -DestinationPath SqlPackage

Write-Host "Writing SqlPackage to Path vso variables"
$sqlPackagePath = "$(Get-Location)\SqlPackage\SqlPackage.exe" 
if (-Not (Test-Path $sqlPackagePath)) {
    throw "Could not find SqlPackage.exe path"
}
echo "##vso[task.setvariable variable=SqlPackagePath]$sqlPackagePath"

Write-Host "removing sqlpackage.zip"
Remove-Item .\sqlPackage.zip