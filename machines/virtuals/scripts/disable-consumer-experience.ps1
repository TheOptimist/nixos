Set-StrictMode -Version Latest
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'
trap {
    Write-Host
    Write-Host "ERROR: $_"
    ($_.ScriptStackTrace -split '\r?\n') -replace '^(.*)$','ERROR: $1' | Write-Host
    ($_.Exception.ToString() -split '\r?\n') -replace '^(.*)$','ERROR EXCEPTION: $1' | Write-Host
    Write-Host
    Write-Host 'Sleeping for 15m to give you time to look around the virtual machine before self-destruction...'
    Start-Sleep -Seconds (15*60)
    Exit 1
}

Write-Host "$(whoami): Disabling the Microsoft Consumer Experience"

$CloudContentPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent'
if (-Not (Test-Path -Path $CloudContentPath)) { New-Item -Path $CloudContentPath -Force | Out-Null }
Set-ItemProperty -Name 'DisableConsumerAccountStateContent' -Value '1' -Path $CloudContentPath -Type DWord | Out-Null
Set-ItemProperty -Name 'DisableCloudOptimizedContent' -Value '1' -Path $CloudContentPath -Type DWord | Out-Null
Set-ItemProperty -Name 'DisableWindowsConsumerFeatures' -Value '1' -Path $CloudContentPath -Type DWord | Out-Null

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
    Write-Host "Disabling $($task.taskName)"
    $task | Disable-ScheduledTask | Out-Null
  }
}