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

# Windows Connect Now
# Microsoft implementation of Wireless Protected Setup (WPS).

# Wi-Fi Direct Services Connection Manager
# Enables direct connections over wireless networks without a router.

# WLAN AutoConfig
# Automatically selects wireless networks and configures adapters.

$Services = @(
  @{ Name = 'wcncsvc';       DisplayName = 'Windows Connect Now (Config Registrar)'}
	@{ Name = 'WFDSConMgrSvc'; DisplayName = 'Wi-Fi Direct Services Connection Manager'}
	@{ Name = 'WlanSvc';       DisplayName = 'WLAN AutoConfig'}
) | ForEach-Object {
	Get-Service -Name $_.Name | Set-Service -StartupType Disabled
	Write-Host "$Runner Disabled '$($_.DisplayName)' service"
}
