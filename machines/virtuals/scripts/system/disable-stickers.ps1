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

# Why do I want to put stickers on my desktop? This is an odd feature...

$RegistryPath = 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Stickers'
if (-Not (Test-Path $RegistryPath)) { New-Item -Path $RegistryPath -Force | Out-Null }
Set-ItemProperty -Name 'EnableStickers' -Value 0 -Type 'DWord' -Path $RegistryPath
Write-Host "$Runner Desktop stickers disabled via registry"
