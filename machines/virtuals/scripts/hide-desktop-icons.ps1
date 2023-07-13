$ExplorerPath = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer'
New-ItemProperty -Path $ExplorerPath -Name 'NoDesktop' -Value '1' -PropertyType DWORD | Out-Null