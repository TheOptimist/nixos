{ pkgs, ...  }:

{
  environment = {
    systemPackages = with pkgs; [ bash fish zsh ];
    shells = with pkgs; [ bash fish zsh ];
  };

  programs.fish.enable = true;
  programs.zsh.enable = true;

  users.defaultUserShell = pkgs.zsh;
}
