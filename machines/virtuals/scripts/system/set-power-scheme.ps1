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

try {

  $HighPerformanceScheme = (powercfg -l | Where-Object { $_ -like '*performance*' }).split()[3]

  # If the name changes at some point, better check if there's a value here...
  if ($null -eq $HighPerformanceScheme) {
    throw "Error: Couldn't find 'High Performance' power scheme from $(powercfg -l)"
  }

  powercfg -setactive $HighPerformanceScheme
  Write-Host "$Runner Power plan set to high performance"
} catch {
  Write-Warning -Message "Unable to set power plan to High Performance"
  Write-Warning $Error[0]
}