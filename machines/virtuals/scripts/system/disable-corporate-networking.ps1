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

# Link-Layer Topology Discovery Mapper
# Creates a network map, consisting of PC and device topology (connectivity) information, and
# metadata describing each PC and device.

# TCP/IP NetBIOS helper
# Provides support for the NetBIOS over TCP/IP (NetBT) service and NetBIOS name resoultion for
# clients on the network, therefore enabling users to share files, print and log on to the network.

# Netlogon (Domain authentication)
# Maintains a secure channel between this computer and the domain controller for authenticating
# users and services.

# Distributed Link Tracking Client
# Maintains links between NTFS files within a computer of across computers in a network.

# Work Folders
# Syncs files with the Work Folders server, enabling use files on any PCs and devices which have
# been setup with Work Folders.
# https://learn.microsoft.com/en-us/windows-server/storage/work-folders/work-folders-overview

$Services = @(
  @{ Name = 'lltdsvc';        DisplayName = 'Link-Layer Topology Discovery Mapper' }
  @{ Name = 'lmhosts';        DisplayName = 'TCP/IP NetBIOS Helper' }
  @{ Name = 'NetLogon';       DisplayName = 'Netlogon' }
  @{ Name = 'TrkWks';         DisplayName = 'Distributed Link Tracking Client'}
  @{ Name = 'workfolderssvc'; DisplayName = 'Work Folders'}
) | ForEach-Object {
    Get-Service -Name $_.Name | Set-Service -StartupType Disabled
    Write-Host "$Runner Disabled '$($_.DisplayName)' service"
}

Disable-WindowsOptionalFeature -Online -FeatureName 'WorkFolders-Client' | Out-Null
Write-Host "$Runner WorkFolder-Client feature disabled"