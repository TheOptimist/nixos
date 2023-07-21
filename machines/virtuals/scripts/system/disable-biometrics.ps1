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

# Windows Hello biometrics lets you sign in to your devices, apps, online services, and networks
# using your face, iric or fingerprint. I'm automatically logging on a user in the virtual
# machines at the moment, so there'd be no need for this. It may be useful for secondary auth
# or verification, but a smart card/key is likely to be the primary mechanic for this.

$RegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Biometrics'
if (-Not (Test-Path $RegistryPath)) { New-Item -Path $RegistryPath -Force | Out-Null }
Set-ItemProperty -Name 'Enabled' -Value 0 -Type 'DWord' -Path $RegistryPath
Write-Host "$Runner Biometrics disabled via registry"

Get-Service -Name WbioSrvc | Set-Service -StartupType Disabled
Write-Host "$Runner Disabled 'Windows Biometric' service"