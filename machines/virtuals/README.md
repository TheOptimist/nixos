# Virtual Machines
A bunch of virtual machines defined by Packer, currently running via libvirtd (virt-manager).

## win_11_base
Base installation of Windows 11 Pro for use by other machine builders. Has a basic bootstrapping
process that removes some pre-provisioned applications, installs updates, and changes a few settings
that I have a preference for.

## work_dev
Builds on the base definition to include developer tools and software that I use whilst at my day job.
This is mostly used because the rest of the team are Windows based developers. I'm trying to do much of
my work on NixOS, but being able to verify everything I change still works on Windows machines is a way
to play nicely with the rest of my team.

## work_vpn
Yep, I have to use a VPN to access some applications. Building a specific machine means this doesn't
get in the way of my day job.

## devices
Right now I don't have a true need for a personal Windows machine, but some of the devices I own don't 
work so well with Linux. Having access to a Windows machine where I can run configuration software for these
devices is incredibly useful, as these settings then sit in the devices, so continue to take effect in my
base NixOS machine.

## Tasks
  - [X] Install base Windows 11 Pro machine
  - [X] Provision base Windows 11 Pro machine
    - [X] Install SPICE tools (Elevate to SYSTEM)
    - [X] Autounattend file
    - [X] Bootstrap
    - [X] Disable user access control
    - [X] Disable telemetry
    - [X] Disable consumer experience
    - [X] Disable unnecessary services
    - [X] Remove provisioned applications
    - [X] Disable scheduled tasks
    - [X] Fix privacy settings
    - [X] Set power scheme (high performance)
    - [X] Disable screensaver
    - [X] Set taskbar properties
    - [X] Hide desktop icons
  - [ ] Provision base personal machine
    - [ ] Install Scoop
      - [ ] Create Scoop bucket containing my apps?
    - [ ] Install Chocolatey? (Some apps are not available via Scoop)
    - [ ] Install PowerShell (via Scoop)
      - [ ] Create personal profile
  - [ ] Provision base Work machine
    - [ ] Disable Xbox related services
    - [ ] Installation of Scoop packages

### Improving
These tasks still need to be carried out manually after the creation of the virtual machine. At some
point it would be good to automate these as well.

  - [ ] Set video options to QXL
  - [ ] Installing Scoop fails because it thinks its still an administrator