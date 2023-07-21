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

# Distrbuted Tracking Coordinator
# Coordinates transactions that span multiple resource managers such as databases, message
# queues, and file systems.

# Function Discovery Provider Host
# Hosts Function Discovery (FD) network for providers who supply network discovery services for
# Simple Services Discovery Protocol (SSDP) and Web Services Discovery (WS-D) protocol.

# Function Discovery Resource Publication
# Publishes this computer and resources attached to this computer so they can be discovered over
# the network.

# Remote Registry
# Enables remote users to modify registry settings on this computer.

# Internet Connection Sharing (ISC)
# Provides network address translation, addressing, name resolution and/or intrusion protection
# services for a home or small office network.

# Simple Services Discovery Protocol
# Discovers networked devices and services that use SSDP such as UPnP devices. Also announces
# devices and services running on the local computer.

# Windows Remote Management
# Standard web services protocol used for remote software and hardware management.

$Services = @(
  @{ Name = 'MSDTC';          DisplayName = 'Distributed Tracking Coordinator' }
  @{ Name = 'fdPHost';        DisplayName = 'Function Discovery Provider Host' }
  @{ Name = 'FDResPub';       DisplayName = 'Function Discovery Resource Publication' }
  @{ Name = 'RemoteRegistry'; DisplayName = 'Remote Registry'}
  @{ Name = 'SharedAccess';   DisplayName = 'Internet Connection Sharing (ICS)'}
  @{ Name = 'WinRM';          DisplayName = 'Windows Remote Management' }
) | ForEach-Object {
    Get-Service -Name $_.Name | Set-Service -StartupType Disabled
    Write-Host "$Runner Disabled '$($_.DisplayName)' service"
}