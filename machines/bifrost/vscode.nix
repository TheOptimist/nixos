{ pkgs, ...  }:

{
  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
      vscodeExtensions = (with vscode-extensions; [
        pkief.material-icon-theme
        pkief.material-product-icons
        streetsidesoftware.code-spell-checker
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