{ pkgs, ... }:

{

  programs.kitty = {
    enable = true;
    theme = "One Dark";
    font = {
      name = "SauceCodePro Nerd Font Mono";
      size = 10;
    };
    shellIntegration.enableZshIntegration = true;
  };
}
