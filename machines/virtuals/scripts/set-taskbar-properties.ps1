### TASKBAR ###

$TaskbandRegistryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband'
# Remove pinned applications
Set-ItemProperty -Path $TaskbandRegistryPath -Name 'Favorites' -Value ([byte[]](0xff))

$ExplorerRegistryPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
# Remove widgets
Set-ItemProperty -Path $ExplorerRegistryPath -Name 'TaskbarDa' -Value '0'
# Removes Chat from the Taskbar
Set-ItemProperty -Path $ExplorerRegistryPath -Name 'TaskbarMn' -Value '0'

# Remove search bar
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' -Name 'SearchboxTaskbarMode' -Value 0