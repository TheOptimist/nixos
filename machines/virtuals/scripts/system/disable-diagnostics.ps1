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

# Diagnostics Hub Standard Collector Service
# Collects real time Event Tracing for Windows ETW events and processes them (sends them somewhere...)

# Diagnostic Execution Service
# Executes diagnostic actions for troubleshooting support.

# Diagnostic Policy Service
# Enables problem detection, troubleshooting and resolution for Windows components.

# Diagnostic Service Host
# Used by Diagnostic Policy Service to host diagnostics that need to run in a Local Service context.

# Diagnostic System Host
# Used by Diagnostic Policy Service to host diagnostics that need to run in a Local System context.

$diagCollector = 'diagnosticshub.standardcollector.service'

$Services = @(
  @{ Name = $diagCollector;   DisplayName = 'Microsoft (R) Diagnostics Hub Standard Collector' }
  @{ Name = 'diagsvc';        DisplayName = 'Diagnostic Execution' }
  @{ Name = 'DPS';            DisplayName = 'Diagnostic Policy' }
  @{ Name = 'WdiServiceHost'; DisplayName = 'Diagnostic Service Host' }
  @{ Name = 'WdiSystemHost';  DisplayName = 'Diagnostic System Host' }
) | ForEach-Object {
    Get-Service -Name $_.Name | Set-Service -StartupType Disabled
    Write-Host "$Runner Disabled '$($_.DisplayName)' service"
}

Disable-WindowsErrorReporting | Out-Null
Write-Host "$Runner Windows error reporting disabled"