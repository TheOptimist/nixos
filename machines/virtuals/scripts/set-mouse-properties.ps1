$MouseControlPanel = 'HKCU:\Control Panel\Mouse'
Set-ItemProperty -Path $MouseControlPath -Name 'MouseSensitivity' -Value '15'