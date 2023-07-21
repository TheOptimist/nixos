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

# Sensor Data Service
# Delivers data from a variety of sensors

# Sensor Monitoring Service
# Monitors various sensors in order to expose data and adapt to system and user state.

# Sensor Service
# Service for sensors that manages different sensors' functionality. Manages Simple Device
# Orientation (SDO) and History for sensors.

$Services = @(
  @{ Name = 'SensorDataService'; DisplayName = 'Sensor Data' }
  @{ Name = 'SensorService';     DisplayName = 'Sensor' }
  @{ Name = 'SensrSvc';          DisplayName = 'Sensor Monitoring' }
) | ForEach-Object {
    Get-Service -Name $_.Name | Set-Service -StartupType Disabled
    Write-Host "$Runner Disabled '$($_.DisplayName)' service"
}