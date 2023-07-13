Set-StrictMode -Version Latest
$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'
trap {
    Write-Host
    Write-Host "ERROR: $_"
    ($_.ScriptStackTrace -split '\r?\n') -replace '^(.*)$','ERROR: $1' | Write-Host
    ($_.Exception.ToString() -split '\r?\n') -replace '^(.*)$','ERROR EXCEPTION: $1' | Write-Host
    Write-Host
    Write-Host 'Sleeping for 15m to give you time to look around the virtual machine before self-destruction...'
    Start-Sleep -Seconds (15*60)
    Exit 1
}

Write-Host "$(whoami): Fixing privacy settings"

Set-WindowsSearchSetting -EnableWebResultsSetting $false

Set-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name "HttpAcceptLanguageOptOut" -Value 1
New-Item -ItemType Directory -Force -Path "HKCU:\Printers\Defaults" | Out-Null
Set-ItemProperty -Path "HKCU:\Printers\Defaults" -Name "NetID" -Value "{00000000-0000-0000-0000-000000000000}"
New-Item -ItemType Directory -Force -Path "HKCU:\SOFTWARE\Microsoft\Input\TIPC" | Out-Null
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Input\TIPC" -Name "Enabled" -Value 0
New-Item -ItemType Directory -Force -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" | Out-Null
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Value 0
