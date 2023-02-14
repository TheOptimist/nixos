{ config, pkgs, lib, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  nix.nixPath =
    [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  nix.package = pkgs.nixFlakes;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # source: https://grahamc.com/blog/erase-your-darlings
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';

  # source: https://grahamc.com/blog/nixos-on-zfs
  boot.kernelParams = [ "elevator=none" ];

  networking.hostId = "0d5142d8";
  networking.hostName = "bifrost";
  networking.useDHCP = false;
  networking.interfaces.enp7s0.useDHCP = true;

  environment.systemPackages = with pkgs; [ git firefox ];

  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
    # TODO: autoReplication
  };

  services.openssh = {
    enable = true;
    settings = {
      permitRootLogin = "yes";
      passwordAuthentication = true;
    };
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  users = {
    mutableUsers = false;
    users = {
      root = {
        initialHashedPassword = "\$6\$4Wn3sb5O0PiXRtCw\$qTEslSEB0uFrWyoIuy7NpCxSH2GmuFfTRtnbDqb30MGZmLqpi7BmcZwC375VN0fkEYY6bGiiE9AlKlc6v0sa31";
      };

      george = {
	uid = 1000;
        isNormalUser = true;
        initialHashedPassword = "\$6\$I/LockFIWSLzZkLY\$xAftwpPCTzg/XwXq77UasTCRU89kF9fJLLFSabdbCaizouVO2Gw/jYfdQfOVtxrNXGwLMJj9JsGZiX5pp953l/";
	group = "users";
	extraGroups = [ "wheel" ];
        createHome = true;
	home = "/home/george";
	useDefaultShell = true;
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
