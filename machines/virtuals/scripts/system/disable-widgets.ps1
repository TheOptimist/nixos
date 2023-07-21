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

$RegistryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty -Name 'TaskbarDa' -Value 0 -Type 'DWord' -Path $RegistryPath
Write-Host "$Runner Widgets removed from the taskbar"

$RegistryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Dsh'
if (-Not (Test-Path $RegistryPath)) { New-Item -Type Directory -Path $RegistryPath -Force | Out-Null }
Set-ItemProperty -Name 'IsPrelaunchEnabled' -Value 0 -Type 'DWord' -Path $RegistryPath
Write-Host "$Runner Widget launching disabled via registry"

$PackageName = 'MicrosoftWindows.Client.WebExperience'
$Package = Get-AppxPackage -Name $PackageName -AllUsers
if ($Package) {
  $Package | Remove-AppxPackage
  Write-Host "$Runner $PackageName appx package removed"
}

$Package = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq $PackageName }
if ($Package) {
  $Package | Remove-AppxProvisionedPackage -Online | Out-Null
  Write-Host "$Runner $PackageName provisioned appx package removed"
}

# Shortcut Windows + W still exists...
