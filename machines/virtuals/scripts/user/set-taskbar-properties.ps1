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

$RegistryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband'
Set-ItemProperty -Name 'Favorites' -Value ([byte[]](0xff)) -Path $RegistryPath
Write-Host "$Runner Pinned applications removed from taskbar"

$RegistryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty -Name 'TaskbarMn' -Value 0 -Type 'DWord' -Path $RegistryPath
Write-Host "$Runner Chat removed from taskbar"

$RegistryPath =  'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search'
Set-ItemProperty -Name 'SearchboxTaskbarMode' -Value 0 -Type 'DWord' -Path $RegistryPath
Write-Host "$Runner Search box removed from taskbar"