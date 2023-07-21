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

Write-Host "$(whoami): Disabling services"

$Services = @(
  'ALG'                                         # Application Layer Gateway Service
  'BDESVC'                                      # BitLocker Drive Encryption Service
  'defragsvc'                                   # Defragmentation (optimize drives)
  
  'fhsvc'                                       # File History Service
  

 
) | ForEach-Object {
    Get-Service -Name $_ | Set-Service -StartupType Disabled
}