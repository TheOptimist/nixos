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

# Windows Terminal is in the 'extras' bucket
if (-Not $(scoop bucket list | Where-Object { $_.Name -eq 'extras') }) {
  scoop bucket add extras
}

scoop install windows-terminal

$WindowsTerminalConfigPath = [IO.Path]::Combine( "${env:XDG_CONFIG_HOME}", 'windows-terminal')
New-Item -ItemType Directory -Path $WindowsTerminalConfigPath -Force

$WindowsTerminalScoopPersistPath = 'C:\users\george\scoop\persist\windows-terminal'
New-Item -ItemType Junction -Name 'settings' -Path $WindowsTerminalScoopPersistPath -Value $WindowsTerminalConfigPath
