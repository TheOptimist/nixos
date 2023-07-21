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

$AppsToRemove = @(
  'Microsoft.MicrosoftStickyNotes'
  'Microsoft.Paint'
  'Microsoft.RawImageExtension'
  'Microsoft.ScreenSketch'
  'Microsoft.Windows.Photos'
  'Microsoft.WindowsCalculator'
  'Microsoft.WindowsNotepad'
  'Microsoft.WindowsTerminal'
)

Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -In $AppsToRemove } | ForEach-Object {
  try {
    $_ | Remove-AppXProvisionedPackage -Online | Out-Null
    Write-Host "$Runner $($_.DisplayName) provisioned package removed"
  } catch {
    Write-Output "$Runner WARN Failed to remove appx '$($_.DisplayName)'"
  }
}

@(
  'Microsoft.MicrosoftStickyNotes'
  'Microsoft.Paint'
  'Microsoft.ScreenSketch'
  'Microsoft.Services.Store.Engagement'
  'Microsoft.Windows.Photos'
  'Microsoft.WindowsCalculator'
  'Microsoft.WindowsCamera'
  'Microsoft.WindowsTerminal'
) | ForEach-Object {
  $app = Get-AppXPackage -AllUsers $_
  if ($app) {
    try {
      "$app" | Remove-AppXPackage -AllUsers | Out-Null
      Write-Host "$Runner $_ package removed"
    } catch {
      Write-Host "WARN Failed to remove appx '$_'"
    }
  }
}