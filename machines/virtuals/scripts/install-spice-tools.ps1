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

# 'S-1-5-32-544' looks like a magic string, smells like a magic string, and tastes like a magic string
# But it's also an ancient magic string - https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-dtyp/81d92bba-d22b-4a8c-908a-554ab29148ab?redirectedfrom=MSDN
$Elevated = @('', '(admin) ')[[Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544']
$Runner = "${Elevated}$(whoami):"

$Drivers = (Get-Volume -FileSystemLabel 'drivers').DriveLetter
& "${Drivers}:\spice-guest-tools-latest.exe" /S

Write-Host "$Runner SPICE tools installed"