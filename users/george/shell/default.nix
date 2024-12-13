{ ...  }:

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

  programs.eza = {
    enable = true;
    enableZshIntegration = false;
    extraOptions = [ "--long" "--group" ];
    icons = "always";
    colors = "always";
    git = true;
  };
  
  programs.jq.enable = true;
}
