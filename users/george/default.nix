{ pkgs, ... }:

{

  home.username = "george";
  home.homeDirectory = "/home/george";

  home.packages = with pkgs; [
    eza
  ];
  
  programs.home-manager.enable = true;

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

  dconf.settings = {
    "org/gnome/shell".enabled-extensions = [
      "appindicatorsupport@rgcjonas.gmail.com"
    ];
  };

#  programs.vscode = {
#    enable = true;
#    extensions = with pkgs.vscode-extensions; [
#      bbenoist.nix
#      pkief.material-icon-theme
#      pkief.material-product-icons
#    ];
    # TODO: Don't put settings here as it makes it harder to change when in Code itself
#    userSettings = {
#      "workbench.startupEditor" = "none";
#      "editor.tabSize" = 2;
#      "editor.indentSize" = "tabSize";
#      "workbench.productIconTheme" = "material-product-icons";
#    };
#  };

  xdg.enable = true;
  xdg.desktopEntries = {
    custom_teams = {
      name = "Microsoft Teams for Linux";
      exec = "${pkgs.teams-for-linux.pname} --defaultURLHandler=${pkgs.microsoft-edge}/bin/microsoft-edge";
      icon = pkgs.teams-for-linux.pname;
      comment = pkgs.teams-for-linux.meta.description;
      categories = [ "Network" "InstantMessaging" "Chat" ];
    };
  };

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
