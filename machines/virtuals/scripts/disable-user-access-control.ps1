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

Write-Host "$(whoami): Disabling user access control"

$SystemPoliciesPath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System'

$WithoutConsent = 0
$UsernamePasswordSecure = 1
$PermitDenySecure = 2
$UsernamePassword = 3
$PermitDeny = 4
$ConsentNonWindows = 5

Set-ItemProperty -Path $SystemPoliciesPath -Name ConsentPromptBehaviorAdmin -Value $WithoutConsent
Set-ItemProperty -Path $SystemPoliciesPath -Name ConsentPromptBehaviorUser -Value $WithoutConsent

Set-ItemProperty -Path $SystemPoliciesPath -Name EnableLUA -Value 0