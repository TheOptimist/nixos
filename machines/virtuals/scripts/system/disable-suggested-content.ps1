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

# Windows offers suggested content in Settings and I don't want it to.

$RegistryPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
if (-Not (Test-Path $RegistryPath)) { New-Item -Path $RegistryPath -Force | Out-Null }
Set-ItemProperty -Name 'SubscribedContent-338393Enabled' -Value 0 -Type 'DWord' -Path $RegistryPath
Set-ItemProperty -Name 'SubscribedContent-353694Enabled' -Value 0 -Type 'DWord' -Path $RegistryPath
Set-ItemProperty -Name 'SubscribedContent-353696Enabled' -Value 0 -Type 'DWord' -Path $RegistryPath
Write-Host "$Runner Suggested content in settings disabled via registry"