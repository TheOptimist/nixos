{ pkgs, ... }:

{

  programs.kitty = {
    enable = true;
    theme = "Gruvbox Dark";
    font = {
      name = "SauceCodePro Nerd Font Mono";
      size = 10;
    };
    settings = {
      modify_font = "baseline 1";
    };
    shellIntegration.enableZshIntegration = true;
  };
}
