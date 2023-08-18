# Bootstraps a Windows machine during an automatic unattended installation
# See https://z8n.eu/2021/11/05/packer-build-windows-with-ssh-communicator/

# Intended to be executed as a SynchronousCommand at FirstLogon, it makes it
# easier to write new functionality than messing around with XML...

# Enable builtin Administrator role
net user administrator /active:yes
wmic useraccount where "name='Administrator'" set PasswordExpires=FALSE

# Install Virtio tools so that QEMU guest agent is running as soon as possible
$Drivers = "$((Get-Volume -FileSystemLabel 'drivers').DriveLetter)"
& "${Drivers}:\virtio-win-guest-tools.exe" /install /norestart /quiet

Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private

# First, make sure WinRM can't be connected to
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new enable=yes action=block

# Delete any existing WinRM listeners
winrm delete winrm/config/listener?Address=*+Transport=HTTP  2>$Null
winrm delete winrm/config/listener?Address=*+Transport=HTTPS 2>$Null

# Disable group policies which block basic authentication and unencrypted login

Set-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client -Name AllowBasic -Value 1
Set-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client -Name AllowUnencryptedTraffic -Value 1
Set-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service -Name AllowBasic -Value 1
Set-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service -Name AllowUnencryptedTraffic -Value 1

Enable-PSRemoting -Force

# Create a new WinRM listener and configure
winrm create winrm/config/listener?Address=*+Transport=HTTP
winrm set winrm/config '@{MaxTimeoutms="7200000"}'

winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="0"}'

winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service '@{MaxConcurrentOperationsPerUser="12000"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

winrm set winrm/config/client '@{AllowUnencrypted="true"}'
winrm set winrm/config/client/auth '@{Basic="true"}'

# Configure UAC to allow privilege elevation in remote shells
$Key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
$Setting = 'LocalAccountTokenFilterPolicy'
Set-ItemProperty -Path $Key -Name $Setting -Value 1 -Force

# Configure and restart the WinRM Service; Enable the required firewall exception
Stop-Service -Name WinRM
Set-Service -Name WinRM -StartupType Automatic
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new enable=yes action=allow localip=any remoteip=any
Start-Service -Name WinRM