{ config, ...  }:

{
  imports = [
    ./fish
    ./zsh
  ];

  programs.starship = {
    enable = true;
  };
}
