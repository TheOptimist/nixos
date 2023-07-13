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

Write-Host "$(whoami): Removing AppX packages"

$AppsToRemove = @(
  'Microsoft.MicrosoftStickNotes'
  'Microsoft.Paint'
  'Microsoft.RawImageExtension'
  'Microsoft.ScreenSketch'
  'Microsoft.Windows.Photos'
  'Microsoft.WindowsCalculator'
  'Microsoft.WindowsNotepad'
  'Microsoft.WindowsTerminal'
)

Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -In $AppsToRemove } | ForEach-Object {
  Write-Host "Removing provisioned appx package '$($_.DisplayName)'"
  try {
    $_ | Remove-AppXProvisionedPackage -Online | Out-Null
  } catch {
    Write-Output "WARN Failed to remove appx '$($_.DisplayName)'"
  }
}

@(
    'MicrosoftStickyNotes'
    'Paint'
    'ScreenSketch'
    'Services.Store.Engagement'
    'Windows.Photos'
    'WindowsCalculator'
    'WindowsCamera'
    'WindowsTerminal'
    'Windows.NarratorQuickStart'
    'Windows.ParentControls'
) | ForEach-Object {

  $app = Get-AppXPackage -AllUsers $_
  if ($app) {
    Write-Host "Removing appx package '$_'"
    try {
      "Microsoft.$app" | Remove-AppXPackage -AllUsers | Out-Null
    } catch {
      Write-Host "WARN Failed to remove appx '$_'"
    }
  }
}