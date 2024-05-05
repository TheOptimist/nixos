{ pkgs, ... }:

{

  programs.kitty = {
    enable = true;
    theme = "One Dark";
    settings = {
      font_family = "SauceCodePro Nerd Font Mono";
      font_size = 10;
      adjust_line_height = "100%";
      adjust_column_width = "100%";
    };
  };
}
