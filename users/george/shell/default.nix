{ config, ...  }:

{
  imports = [
    ./fish
    ./zsh
  ];

  programs.starship = {
    enable = true;
  };
  xdg.configFile."starship.toml".source = ./starship.toml;

  programs.bat.enable = true;
  xdg.configFile."bat/config".text = ''
    --theme="gruvbox-dark"
  '';

  programs.eza.enable = true;
  home.sessionVariables.EZA_ICONS_AUTO = "true";

  programs.jq.enable = true;
}
