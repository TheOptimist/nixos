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

$gitConfigHome = [IO.Path]::Combine( "${env:XDG_CONFIG_HOME}", 'git', 'gitconfig')
[System.Environment]::SetEnvironmentVariable('GIT_CONFIG_GLOBAL', $gitConfigHome, 'USER')
Write-Host "$Runner Set GIT_CONFIG_GLOBAL environment variable"

scoop install git

git config --global --bool push.autoremote true
git config --global core.sshcommand ((Get-Command ssh).Source -replace '\\','/')
