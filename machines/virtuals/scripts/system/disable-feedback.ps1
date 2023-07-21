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

# Windows 11 asks for feedback. Let's tell it to stop asking.

$RegistryPath = 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules'
if (-Not (Test-Path $RegistryPath)) { New-Item -Path $RegistryPath -Force | Out-Null }
Set-ItemProperty -Name 'PeriodInNanoSeconds' -Value 0 -Type 'DWord' -Path $RegistryPath
Set-ItemProperty -Name 'NumberOfSIUDInPeriod' -Value 0 -Type 'DWord' -Path $RegistryPath
Write-Host "$Runner Feedback requests have been disabled via registry"