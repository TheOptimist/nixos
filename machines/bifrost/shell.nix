{ pkgs, ...  }:

{
  environment = {
    systemPackages = with pkgs; [ bash fish ];
    shells = with pkgs; [ bash fish ];
  };

  programs.fish.enable = true;

  users.defaultUserShell = pkgs.fish;
}
