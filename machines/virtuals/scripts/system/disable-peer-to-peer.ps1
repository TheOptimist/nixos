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

# Peer Name Resolution Protocol
# Enables serverless peer name resolution over the Internet using the Peer Name Resolution
# Protocl (PNRP).

# Peer Networking Grouping
# Enables multi-party communication using Peer-to-Peer grouping.

# Peer Networking Identity Manager
# Provides identity services for the PNRP and Peer-to-Peer Grouping services.

$Services = @(
  @{ Name = 'PNRPsvc';  DisplayName = 'Peer Name Resolution Protocol' }
  @{ Name = 'p2pimsvc'; DisplayName = 'Peer Networking Identity Manager' }
  @{ Name = 'p2psvc';   DisplayName = 'Peer Networking Grouping' }
) | ForEach-Object {
    Get-Service -Name $_.Name | Set-Service -StartupType Disabled
    Write-Host "$Runner Disabled '$($_.DisplayName)' service"
}