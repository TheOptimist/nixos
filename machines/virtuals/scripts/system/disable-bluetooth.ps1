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

# Bluetooth Audio Gateway
# Service supporting the audio gateway role of the BT handsfree profile.

# Audio Video Control Transport Protocol
# Enables support of more than one control profile at a time.
# https://www.bluetooth.com/specifications/specs/a-v-control-transport-protocol-1-4/

# Bluetooth Support
# Enables discovery and association of remote BT devices.

# Bluetooth User Support
# Supports proper functionality of BT features relevant to each user session.

$Services = @(
  @{ Name = 'BTAGService';                DisplayName = 'Bluetooth Audio Gateway' }
  @{ Name = 'BthAvctpSvc';                DisplayName = 'Audio Video Control Transport Protocol' }
  @{ Name = 'bthserv';                    DisplayName = 'Bluetooth Support' }
) | ForEach-Object {
    Get-Service -Name $_.Name | Set-Service -StartupType 'Disabled'
    Write-Host "$Runner Disabled '$($_.DisplayName)' service"
}

# $UserService = Get-Service | Where-Object { $_.Name -like '*BluetoothUserService*' }
# if ($UserService) { 
#   $UserService | Set-Service -StartupType 'Disabled'
#   Write-Host "$Runner Disabled Bluetooth User Service"
# }