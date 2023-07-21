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

# Wherever you go, Windows 11 knows where you are. When location tracking is turned on,
# Windows and its apps are allowed to detect the current location of your computer or
# device. Only useful in very some specific situations, and not much need for it for
# the target here, which is a virtual machine resides in a place that doesn't change.

$RegistryPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location'
if (-Not (Test-Path $RegistryPath)) { New-Item -Path $RegistryPath -Force | Out-Null }
Set-ItemProperty -Name 'Value' -Value 'Deny' -Type 'String' -Path $RegistryPath
Write-Host "$Runner Location tracking disabled via registry"

Get-Service -Name 'lfsvc' | Set-Service -StartupType Disabled
Write-Host "$Runner Disabled 'Geolocation' service"