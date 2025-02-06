{ pkgs, ...  }:

{
  boot.kernelModules = [ "kvm-amd" ];

  # Enable nested virtualisation inside the guests?
  # boot.extraModprobeConfig = "options kvm_amd nested=1";

  virtualisation = {
    libvirtd = {
      enable = true;
      allowedBridges = [ "br0" "virbr0" ];
      qemu = {
        runAsRoot = true;
        swtpm.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };

  environment.systemPackages = with pkgs; [
    virt-manager
    swtpm
    remmina
  ];
}
