{ config, pkgs, ... }:

{

  home.username = "george";
  home.homeDirectory = "/home/george";

  home.packages = with pkgs; [
    exa
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

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      pkief.material-icon-theme
      pkief.material-product-icons
    ];
    userSettings = {
      "workbench.startupEditor" = "none";
      "editor.tabSize" = 2;
      "editor.indentSize" = "tabSize";
      "workbench.productIconTheme" = "material-product-icons";
    };
  };

  xdg.enable = true;
  
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
