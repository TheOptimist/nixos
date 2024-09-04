{ pkgs, ...  }:

let
  functions = builtins.readFile ./functions.sh;

in {
  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";

    history = {
      path = "$ZDOTDIR/history";
      size = 5000;
      save = 50000;
      ignoreAllDups = true;
      ignorePatterns = [
        "ls"
        "cd"
        "rm"
        "mv"
      ];
      ignoreSpace = true;
    };

    shellAliases = {
      ls = "eza";
    };

    initExtra = ''
      ${functions}
    '';
  };
}
