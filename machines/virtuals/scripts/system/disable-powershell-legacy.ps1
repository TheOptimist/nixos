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

Disable-WindowsOptionalFeature -Online -FeatureName 'MicrosoftWindowsPowerShellV2' | Out-Null
Write-Host "$Runner MicrosoftWindowsPowerShellV2 optional feature disabled"

Disable-WindowsOptionalFeature -Online -FeatureName 'MicrosoftWindowsPowerShellV2Root' | Out-Null
Write-Host "$Runner MicrosoftWindowsPowerShellV2Root optional feature disabled"
