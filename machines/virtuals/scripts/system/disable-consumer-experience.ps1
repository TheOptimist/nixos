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

# Windows 11 automatically installs some applications for a signed in user.

$RegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent'
if (-Not (Test-Path $RegistryPath)) { New-Item -Path $RegistryPath -Force | Out-Null }
Set-ItemProperty -Name 'DisableConsumerAccountStateContent' -Value '1' -Path $RegistryPath -Type DWord | Out-Null
Set-ItemProperty -Name 'DisableCloudOptimizedContent' -Value '1' -Path $RegistryPath -Type DWord | Out-Null
Set-ItemProperty -Name 'DisableWindowsConsumerFeatures' -Value '1' -Path $RegistryPath -Type DWord | Out-Null
Write-Host "$Runner Consumer experiences disabled via registry"

# Scheduled Tasks
@(
  'Microsoft Compatibility Appraiser'
  'Proxy'
  'Consolidator'
  'UsbCeip'
  'Microsoft-Windows-DiskDiagnosticDataCollector'
) | ForEach-Object {
  $task = Get-ScheduledTask -TaskName "$_" -ErrorAction SilentlyContinue
  if ($task) {
    Write-Host "$Runner Disabled task '$($task.taskName)'"
    $task | Disable-ScheduledTask | Out-Null
  }
}

$RegistryPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
if (-Not (Test-Path $RegistryPath)) { New-Item -Path $RegistryPath -Force | Out-Null }
Set-ItemProperty -Name 'SilentInstalledAppsEnabled' -Value 0 -Type 'DWord' -Path $RegistryPath
Write-Host "$Runner Silent installation of suggested apps disabled via registry"