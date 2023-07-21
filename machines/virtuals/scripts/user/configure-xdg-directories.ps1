Set-StrictMode -Version Latest
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'
trap {
    Write-Host
    Write-Host "ERROR: $_"
    ($_.ScriptStackTrace -split '\r?\n') -replace '^(.*)$','ERROR: $1' | Write-Host
    ($_.Exception.ToString() -split '\r?\n') -replace '^(.*)$','ERROR EXCEPTION: $1' | Write-Host
    Exit 1
}

$AdministratorRole = [Security.Principal.WindowsBuiltInRole]::Administrator
$CurrentIdentity = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
$Elevated = @('', '(admin) ')[$CurrentIdentity.IsInRole($AdministratorRole)]
$Runner = "${Elevated}$(whoami):"

$xdgConfigHome = [IO.Path]::Combine( "${env:USERPROFILE}", '.config')
[System.Environment]::SetEnvironmentVariable('XDG_CONFIG_HOME', $xdgConfigHome, 'USER')
Write-Host "$Runner Set XDG_CONFIG_HOME environment variable"

$xdgDataHome = [IO.Path]::Combine( "${env:USERPROFILE}", '.local', 'share')
[System.Environment]::SetEnvironmentVariable('XDG_DATA_HOME', $xdgDataHome, 'USER')
Write-Host "$Runner Set XDG_DATA_HOME environment variable"
