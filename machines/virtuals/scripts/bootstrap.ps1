# Bootstraps a Windows machine during an automatic unattended installation
# See https://z8n.eu/2021/11/05/packer-build-windows-with-ssh-communicator/

# Intended to be executed as a SynchronousCommand at FirstLogon, it makes it
# easier to write new functionality in that messing around with XML...

# Enable builtin Administrator role
net user administrator /active:yes

$Drive = "$((Get-Volume -FileSystemLabel 'drivers').DriveLetter):"
$SpiceGuestTools = "$Drive\virtio-win-guest-tools.exe"
& "$SpiceGuestTools" /install /norestart /quiet

# Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

# Add Microsoft OpenSSH server (apparently naming stuff is hard...)
Add-WindowsCapability -Online -Name "OpenSSH.Server~~~~0.0.1.0"

# Start the service, and make it start on boot
Start-Service sshd
Set-Service -Name sshd -StartupType automatic

# Permit 'Users' group to use SSH service
"AllowGroups Users" | Add-Content -Path C:\ProgramData\ssh\sshd_config

# Add firewall exception (this should be last, as Packer will connect at this point)
$OpenSSHFirewallParams = @{
  Name = 'OpenSSH-Server-In-TCP'
  DisplayName = 'OpenSSH Server (sshd)'
  Enabled = $true
  Direction = 'Inbound'
  Protocol = 'TCP'
  Action = 'Allow'
  LocalPort = 22  
}
New-NetFirewallRule @OpenSSHFirewallParams