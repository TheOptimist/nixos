{ pkgs, ... }:

{
  imports = [
    ./shell
    ./terminal.nix
  ];

  home.username = "george";
  home.homeDirectory = "/home/george";

  home.sessionVariables = {
    AWS_CONFIG_FILE = "\${XDG_CONFIG_HOME}/aws/config";
    AWS_DATA_PATH = "\${XDG_DATA_HOME}/aws/modles";
    AWS_SHARED_CREDENTIALS_FILE = "\${XDG_CONFIG_HOME}/aws/credentials";
    AWS_DEFAULT_OUTPUT = "json";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    pinta
    hugo
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "George Cover";
    userEmail = "5285122+TheOptimist@users.noreply.github.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  xdg.configFile."git/config_work".text = ''
[user]
    name = "George Cover"
    email = "gcover@uplandsoftware.com"
'';

  dconf.settings = {
    "org/gnome/shell".enabled-extensions = [
      "appindicatorsupport@rgcjonas.gmail.com"
    ];
  };
  xdg.enable = true;

  xdg.configFile."teams-for-linux/config.json".text = ''
{
  "defaultURLHandler": "${pkgs.microsoft-edge}/bin/microsoft-edge",
  "closeAppOnCross": true,
  "optInTeamsV2": true
}
'';

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";
}
