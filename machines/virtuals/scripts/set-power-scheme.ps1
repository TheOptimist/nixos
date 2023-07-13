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

Write-Host "$(whoami): Setting power scheme (high performance)"

try {

  $HighPerformanceScheme = (powercfg -l | Where-Object { $_ -like '*performance*' }).split()[3]

  # If the name changes at some point, better check if there's a value here...
  if ($null -eq $HighPerformanceScheme) {
    throw "Error: Couldn't find 'High Performance' power scheme from $(powercfg -l)"
  }

  powercfg -setactive $HighPerformanceScheme
} catch {
  Write-Warning -Message "Unable to set power plan to High Performance"
  Write-Warning $Error[0]
}