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

# Cellular Time (from NITZ messages)
# This machine is not a cell phone so doesn't need Network Identity and Time Zone

# Windows Mobile Hotspot Service
# This machine is not going to be tethering to a cell phone hotspot

# Phone Service
# This machine will not be integrating with my phone

# Radio Management and Airplane Mode
# Enables the operating system to identify the status of a (hardware) switch and control the
# various wireless radios via software.

# Payments and NFC/SE Manager
# Manages payments and Near Field Communication (NFC) based secure elements.

# Wireless WAN AutoConfig
# Manages modile broadband (GSM & CDMA) data card/embedded module adapters and connections
# by auto-configuring the networks.

$Services = @(
  @{ Name = 'autotimesvc'; DisplayName = 'Cellular Time (from NITZ messages)' }
  @{ Name = 'icssvc';      DisplayName = 'Windows Mobile Hotspot Service' }
  @{ Name = 'PhoneSvc';    DisplayName = 'Phone Service' }
  @{ Name = 'RmSvc';       DisplayName = 'Radio Management and Airplane Mode' }
  @{ Name = 'SEMgrSvc';    DisplayName = 'Payments and NFC/SE Manager' }
  @{ Name = 'WwanSvc';     DisplayName = 'Wireless WAN AutoConfig' }
) | ForEach-Object {
    Get-Service -Name $_.Name | Set-Service -StartupType Disabled
    Write-Host "$Runner Disabled '$($_.DisplayName)' service"
}