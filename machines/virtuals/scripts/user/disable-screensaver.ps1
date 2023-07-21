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

Set-ItemProperty 'HKCU:\Control Panel\Desktop' -Name 'ScreenSaveAction' -Value 0 -Type 'Dword'
Write-Host "$Runner Screensaver disabled via registry"

# These are set to zero with high performance plan anyway...
powercfg -x monitor-timeout-ac 0
powercfg -x monitor-timeout-dc 0
Write-Host "$Runner Monitor timeout (ac/dc) set to 0 via powercfg"