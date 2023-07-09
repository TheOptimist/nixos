packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.9"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

variable "name" {
  type = string
  default = "test"
}

variable "cpus" {
  type = number
  default = 8
}

variable "memory" {
  type = number
  default = 16384
}

variable capacity { 
  type = string
  default = "64G"
}

source "qemu" "base_windows" {
  vm_name = var.name
  output_directory = "/rpool/safe/images/${var.name}"
  
  accelerator = "kvm"
  machine_type = "q35"

  qemuargs = [
    ["-cpu", "host,topoext"],
    ["-device", "qemu-xhci"],
    //["-device", "virtio-tablet"],
    //["-device", "virtio-scsi-pci,id=scsi0"],
    //["-device", "scsi-hd,bus=scsi0.0,drive=drive0"],
    //["-device", "virtio-net,netdev=user.0"],
    //["-device", "tpm-tis,tpmdev=tpm0"],
    ["-vga", "qxl"],
    //["-device", "virtio-serial-pci"],
    //["-chardev", "socket,path=/tmp/{{ .Name }}-qga.sock,server=on,wait=off,id=qga0"],
    //["-device", "virtserialport,chardev=qga0,name=org.qemu.guest_agent.0"],
    //["-chardev", "spicevmc,id=spicechannel0,name=vdagent"],
    //["-device", "virtserialport,chardev=spicechannel0,name=com.redhat.spice.0"],
    //["-spice", "unix=on,addr=/tmp/{{ .Name }}-spice.socket,disable-ticketing=on"],
  ]

  efi_boot = true
  efi_firmware_code = "/run/libvirt/nix-ovmf/OVMF_CODE.fd"
  efi_firmware_vars = "/run/libvirt/nix-ovmf/OVMF_VARS.fd"

  cpus = 8
  sockets = 1
  cores = 4
  threads = 2
  memory = var.memory

  // vtpm = true
  // tpm_device_type = "tpm-tis"

  net_bridge = "br0"
 
  disk_size = var.capacity
  format = "qcow2"

  iso_url = "/home/george/ISOs/Win11_22H2_English_x64v2.iso"
  iso_checksum = "8059a99b8902906a90afe068ac00465c52588c2bd54f5d9d96c1297f88ef1076"

  floppy_content = {
    "autounattend.xml" = templatefile("${path.root}/autounattend.pkrtpl.hcl", { localUser = "george", computerName = var.name })
  }

  cd_files = [ "/home/george/ISOs/drivers/*" ]
  cd_label = "virtio"

  boot_wait = "1s"
  boot_command   = [ "<up><wait><up><wait><up><wait><up><wait><up><wait15m>" ]

  communicator = "winrm"
  winrm_username = "packer"
  winrm_password = "packer"
  winrm_timeout = "6h"

  shutdown_command = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
}

build {
  sources = [ "source.qemu.base_windows" ]
}