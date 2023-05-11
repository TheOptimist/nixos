{ config, pkgs, lib, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  nix.nixPath =
    [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/home/george/.nixos/flake.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  nix.package = pkgs.nixFlakes;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.plymouth.enable = true;

  # source: https://grahamc.com/blog/erase-your-darlings
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';

  virtualisation.libvirtd = {
   enable = true;
   qemu.runAsRoot = true;
   qemu.ovmf.enable = true;
   qemu.ovmf.packages = [ pkgs.OVMFFull ];
   qemu.swtpm.enable = true;
  };
  
  programs.dconf.enable = true;

  time.timeZone = "America/Toronto";

  security.sudo.wheelNeedsPassword = false;

  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  networking.hostId = "0d5142d8";
  networking.hostName = "bifrost";

  networking.useDHCP = false;
  networking.interfaces.enp7s0.useDHCP = true;
  networking.interfaces.br0.useDHCP = true;
  networking.bridges.br0.interfaces = [ "enp7s0" ];
  
  systemd.services.NetworkManager.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;

  environment.systemPackages = with pkgs; [
    git
    firefox
    autorandr
    virt-manager
    lastpass-cli
    element-desktop
    google-chrome
  ];
  
  services.pcscd.enable = true;
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  # for a WiFi printer
  services.avahi.openFirewall = true;

  services.autorandr = {
    enable = true;
    defaultTarget = "working";
    profiles = {
      "working" = {
        fingerprint = {
          "DP-0" = "00ffffffffffff0010acc1d0545039301f1b0104a5351e783aad75a9544d9d260f5054a54b008100b300d100714fa9408180d1c00101565e00a0a0a02950302035000e282100001a000000ff0032394a3050373836303950540a000000fc0044454c4c205032343138440a20000000fd0031561d711c010a20202020202001f8020315b15090050403020716010611121513141f20023a801871382d40582c45000e282100001e011d8018711c1620582c25000e282100009ebf1600a08038134030203a000e282100001a7e3900a080381f4030203a000e282100001a0000000000000000000000000000000000000000000000000000000000000000000062";
          "DP-2" = "00ffffffffffff0010acc1d054454330271b0104a5351e783aad75a9544d9d260f5054a54b008100b300d100714fa9408180d1c00101565e00a0a0a02950302035000e282100001a000000ff0032394a3050373952304345540a000000fc0044454c4c205032343138440a20000000fd0031561d711c010a20202020202001d5020315b15090050403020716010611121513141f20023a801871382d40582c45000e282100001e011d8018711c1620582c25000e282100009ebf1600a08038134030203a000e282100001a7e3900a080381f4030203a000e282100001a0000000000000000000000000000000000000000000000000000000000000000000062";
          "DP-4" = "00ffffffffffff0010acc1d054414430271b0104a5351e783aad75a9544d9d260f5054a54b008100b300d100714fa9408180d1c00101565e00a0a0a02950302035000e282100001a000000ff0032394a3050373952304441540a000000fc0044454c4c205032343138440a20000000fd0031561d711c010a20202020202001db020315b15090050403020716010611121513141f20023a801871382d40582c45000e282100001e011d8018711c1620582c25000e282100009ebf1600a08038134030203a000e282100001a7e3900a080381f4030203a000e282100001a0000000000000000000000000000000000000000000000000000000000000000000062";
        };
        config = {
          "DP-0" = {
            enable = true;
            position = "0x0";
            mode = "2560x1440";
            rotate = "right";
          };
          "DP-4" = {
            enable = true;
            position = "1440x524";
            mode = "2560x1440";
            primary = true;
          };
          "DP-2" = {
            enable = true;
            position = "4000x0";
            mode = "2560x1440";
            rotate = "left";
          };
        };
      };
    };
  };

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
    # Not really sure I like this approach tbh. It does work for the login screen, but autorandr
    # still needs to run on user login, otherwise the display characteristics are reset
    displayManager.setupCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output DP-0 --mode 2560x1440 --pos 0x0 --rotate right
      ${pkgs.xorg.xrandr}/bin/xrandr --output DP-4 --mode 2560x1440 --pos 1440x524 --rotate normal --primary
      ${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --mode 2560x1440 --pos 4000x0 --rotate left
    '';
    desktopManager.gnome.enable = true;

    videoDrivers = [ "nvidia" ];
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
        extraGroups = [ "wheel" "libvirtd" ];
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
