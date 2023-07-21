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

# GameDVR and Broadcast User Service
# Used for Game Recordings and Live broadcasts.

# Xbox Accessory Management Service
# Manages connected Xbox accessories.

# Xbox Live Auth Manager
# Provides authentication and authorization services for interacting with Xbox Live.

# Xbox Live Game Save
# Syncs save data for Xbox Live save enabled games.

# Xbox Live Networking Service
# Supports the Windows.Networking.XboxLive application programming interface.

$Services = @(
  @{ Name = 'XboxGipSvc';                DisplayName = 'Xbox Accessory Management' }
  @{ Name = 'XblAuthManager';            DisplayName = 'Xbox Live Auth Manager' }
  @{ Name = 'XblGameSave';               DisplayName = 'Xbox Live Game Save' }
  @{ Name = 'XboxNetApiSvc';             DisplayName = 'Xbox Live Networking' }
) | ForEach-Object {
	Get-Service -Name $_.Name | Set-Service -StartupType Disabled
	Write-Host "$Runner Disabled '$($_.DisplayName)' service"
}

# $Userervice = Get-Service | Where-Object { $_.Name -like '*BcastDVRUserService*' }
# if ($UserService) { 
#   $UserService | Set-Service -StartupType 'Disabled'
#   Write-Host "$Runner Disabled Bluetooth User Service"
# }
