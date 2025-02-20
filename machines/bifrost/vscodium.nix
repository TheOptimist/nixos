{ pkgs, ...  }:

{
  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = (with open-vsx; [
        pkief.material-icon-theme
        pkief.material-product-icons
        streetsidesoftware.code-spell-checker
        jeanp413.open-remote-ssh
        usernamehw.errorlens
        eamodio.gitlens
        yzhang.markdown-all-in-one
        jdinhlife.gruvbox
        jnoortheen.nix-ide
        gruntfuggly.todo-tree
        tamasfe.even-better-toml
      ]);
    })
  ];
    # TODO: Don't put settings here as it makes it harder to change when in Code itself
#    userSettings = {
#      "workbench.startupEditor" = "none";
#      "editor.tabSize" = 2;
#      "editor.indentSize" = "tabSize";
#      "workbench.productIconTheme" = "material-product-icons";
#    };
#  };
}