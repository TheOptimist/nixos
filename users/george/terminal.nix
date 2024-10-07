{ pkgs, ... }:

{

  programs.kitty = {
    enable = true;
    themeFile = "GruvboxMaterialDarkHard";
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
