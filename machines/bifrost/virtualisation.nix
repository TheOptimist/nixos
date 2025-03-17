{ pkgs, ...  }:

{
  boot.kernelModules = [ "kvm-amd" ];

  # Enable nested virtualisation inside the guests?
  # boot.extraModprobeConfig = "options kvm_amd nested=1";

  virtualisation = {
    # qemu = {
    #   options = [ "-accel kvm" ];
    # };

    libvirtd = {
      enable = true;
      allowedBridges = [ "br0" "virbr0" ];
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf.packages = [ (pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };

    spiceUSBRedirection.enable = true;

    podman = {
      enable = true;
      # Creates a 'docker' alias for podman, to enable use as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    swtpm
    remmina

    # Useful development tools for docker/podman
    dive
    podman-tui
  ];
}
