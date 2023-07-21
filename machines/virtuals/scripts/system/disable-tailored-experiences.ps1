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

# Windows 11 will provide relevant tips and recommendations by using your diagnostic data. 
# Sounds suspiciously like telemetry...maybe even spying.

$RegistryPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy'
if (-Not (Test-Path $RegistryPath)) { New-Item -Path $RegistryPath -Force | Out-Null }
Set-ItemProperty -Name 'TailoredExperiencesWithDiagnosticDataEnabled' -Value 0 -Type 'DWord' -Path $RegistryPath
Write-Host "$Runner Diagnostic data disabled via registry"