<#
        .SYNOPSIS
        Publish-DacPac allows you to deploy a SQL Server Database using a DACPAC to a SQL Server instance.
 
        .DESCRIPTION
        Publishes a SSDT DacPac to a SQL Server instances and database
 
        .PARAMETER sqlUserName
        SQL Login user name

        .PARAMETER sqlUserPassword
        SQL Login user password

        .PARAMETER sqlServerName
        Target SQL Server Instance name or URL

        .PARAMETER databaseName
        Target database name

        .PARAMETER dacpacPath
        Full path to your database DACPAC (e.g. C:\Dev\YourDB\bin\Debug\YourDB.dacpac)
 

        .EXAMPLE
        Publish-DacPac -DacPacPath "C:\Dev\YourDB\bin\Debug\YourDB.dacpac" -DacPublishProfile "YourDB.CI.publish.xml" -TargetServerName "YourDBServer"
    #>
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)] [string] $sqlUserName,
    [Parameter(Mandatory = $true)] [string] $sqlUserPassword,
    [Parameter(Mandatory = $true)] [string] $sqlServerName,
    [Parameter(Mandatory = $true)] [string] $databaseName,
    [Parameter(Mandatory = $true)] [string] $dacpacPath
)

$global:ErrorActionPreference = 'Stop';
$sqlPackagePath = Get-Command sqlpackage -all | Select-Object -first 1 -ExpandProperty Source
if (-Not (Test-Path $sqlPackagePath)) {
    throw "Could not find SqlPackage.exe path"
}
if (-Not (Test-Path $dacpacPath)) {
    throw "$dacpac path does not exist"
}

& $sqlPackagePath /a:Publish `
    /tsn:$sqlServerName `
    /tdn:$databaseName `
    /tu:$sqlUserName `
    /tp:$sqlUserPassword `
    /sf:$dacpacPath