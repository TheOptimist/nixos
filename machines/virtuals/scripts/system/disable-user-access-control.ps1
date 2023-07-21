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

# Don't completely diable user access control. This has a side effect (if you're an admin) of
# starting *every* process as elevated. Reducing impact on me as a user.

$RegistryPath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'

# https://learn.microsoft.com/en-us/windows/security/application-security/application-control/user-account-control/settings-and-configuration?tabs=reg

# ConsentPromptBehaviorAdmin
# 0 - Elevate without prompting
# 1 - Prompt for credentials on secure desktop
# 2 - Prompt for consent on secure desktop
# 3 - Prompt for credentials
# 4 - Prompt for consent
# 5 - (Default) Prompt for consent for non-Windows binaries
Set-ItemProperty -Name 'ConsentPromptBehaviorAdmin' -Value 4 -Type 'DWord' -Path $RegistryPath
Write-Host "$Runner Prompting for consent (without secure desktop) via registry"

Set-ItemProperty -Name 'PromptOnSecureDesktop' -Value 0 -Type 'DWord' -Path $RegistryPath
Write-Host "$Runner Prompting on secure desktop disabled via registry"

# ConsentPromptBehaviorAdmin
# 0 - Automatically deny elevation requests
# 1 - Prompt for credentials on the secure desktop
# 3 -(Default) Prompt for Credentials

# Set-ItemProperty -Path $RegistryPath -Name EnableLUA -Value 0