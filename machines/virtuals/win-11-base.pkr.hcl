
packer {
  required_plugins {
    libvirt = {
      version = ">= 0.5.0"
      source  = "github.com/thomasklein94/libvirt"
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

variable localUser {
  type = string
  default = "george"
}

variable localUserPassword {
  type = string
  default = "password"
}

variable administratorPassword {
  type = string
  default = "password"
}

source "libvirt" "win_11_base" {
  libvirt_uri = "qemu:///system"
  domain_name = var.name

  chipset = "q35"
  arch = "x86_64"

  loader_path = "/run/libvirt/nix-ovmf/OVMF_CODE.fd"
  loader_type = "pflash"
  nvram_path = "/var/lib/libvirt/qemu/nvram/${var.name}_VARS.fd"
  nvram_template = "/run/libvirt/nix-ovmf/OVMF_VARS.fd"

  vcpu = var.cpus
  cpu_mode = "host-passthrough"
  memory = var.memory

  boot_devices = [ "cdrom", "hd" ]

  volume {
    pool = "default"
    alias = "artifact"
    device = "disk"
    bus = "sata"

    name = "${var.name}.qcow2"
    size = var.capacity
    capacity = var.capacity
  }

  volume {
    pool = "isos"
    name = "${var.name}_installer"
    format = "raw"
    device = "cdrom"
    bus = "sata"

    source {
      type = "external"
      urls = [ "/home/george/ISOs/Win11_22H2_English_x64v2.iso" ]
      checksum = "8059a99b8902906a90afe068ac00465c52588c2bd54f5d9d96c1297f88ef1076"
    }
  }

  volume {
    pool = "tmp"
    name = "${var.name}_unattend"
    alias = "unattend"
    device = "floppy"

    source {
      type = "files"
      label = "unattend"
      contents = {
        "autounattend.xml" = templatefile("${path.root}/autounattend.pkrtpl.hcl", {
          computerName = var.name,
          localUser = var.localUser,
          localUserPassword = var.localUserPassword,
          administratorPassword = var.administratorPassword
        }),
        "bootstrap.ps1" = file("${path.root}/scripts/bootstrap.ps1")
      }
    }
  }

  volume {
    pool = "isos"
    name = "${var.name}_drivers"
    format = "raw"
    device = "cdrom"
    bus = "sata"

    source {
      type = "files"
      label = "drivers"
      files = [ "/home/george/ISOs/drivers/*" ]
    }
  }

  network_interface {
    type = "bridge"
    alias = "bridge"
    bridge = "br0"
    model = "virtio"
  }
  network_address_source = "agent"

  graphics {
    type = "vnc"
  }

  boot_wait = "1s"
  boot_command = [
    "<up><wait><up>"
  ]

  communicator_interface = "bridge"
  communicator {
    communicator = "ssh"
    ssh_username = var.localUser
    ssh_password = var.localUserPassword
    ssh_timeout = "1h"
  }

  shutdown_timeout = "15m"
}

build {
  sources = [ "source.libvirt.win_11_base" ]

  provisioner "powershell" {
    script = "./scripts/set-power-scheme.ps1"
  }
}