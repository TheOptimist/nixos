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

# Windows collects usage information from diagnostic data. No thank you.

$RegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection'
if (-Not (Test-Path $RegistryPath)) { New-Item -Path $RegistryPath -Force | Out-Null }
Set-ItemProperty -Name 'AllowTelemetry' -Value 0 -Type 'DWord' -Path $RegistryPath
Write-Host "$Runner Telemetry disabled via registry"

$RegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurretnVersion\Policies\DataCollection'
if (-Not (Test-Path $RegistryPath)) { New-Item -Path $RegistryPath -Force | Out-Null }
Set-ItemProperty -Name 'AllowTelemetry' -Value 0 -Type 'DWord' -Path $RegistryPath
Write-Host "$Runner Telemetry policy disabled via registry"

Set-Service -Name 'DiagTrack' -StartupType 'Disabled'
Write-Host "$Runner DiagTrack service disabled"

$RegistryPath = 'HKLM:\SYSTEM\ControlSet001\Services\DiagTrack'
if (-Not (Test-Path $RegistryPath)) { New-Item -Path $RegistryPath -Force | Out-Null }
Set-ItemProperty -Name 'Start' -Value 4 -Type 'DWord' -Path $RegistryPath
Write-Host "$Runner DiagTrack service disabled via registry"

[System.Environment]::SetEnvironmentVariable('DOTNET_CLI_TELEMETRY_OPTOUT', 1, 'MACHINE')
Write-Host "$Runner Dotnet cli telemetry disabled with environment variable"

[System.Environment]::SetEnvironmentVariable('POWERSHELL_TELEMETRY_OPTOUT', 1, 'MACHINE')
Write-Host "$Runner Powershell telemetry disabled with environment variable"

# TODO: Disable communication to telemetry hosts/ips via local hosts file? blackhole dns? network?