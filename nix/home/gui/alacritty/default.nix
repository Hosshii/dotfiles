{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        startup_mode = "Maximized";
      };

      font = {
        normal = {
          family = "HackGen35 Console NF";
          style = "Regular";
        };
        size = 13;
        offset = {
          x = 1;
          y = 1;
        };
      };

      terminal = {
        shell = {
          program = "${pkgs.zsh}/bin/zsh";
          args = [
            "-l"
            "-c"
            "tmux a -t 0 || tmux"
          ];
        };
      };

      # Colors (Solarized Light)
      colors = {
        primary = {
          background = "#fdf6e3";
          foreground = "#586e75";
        };

        # Normal colors
        normal = {
          black = "#073642";
          red = "#dc322f";
          green = "#859900";
          yellow = "#b58900";
          blue = "#268bd2";
          magenta = "#d33682";
          cyan = "#2aa198";
          white = "#eee8d5";
        };

        # Bright colors
        bright = {
          black = "#002b36";
          red = "#cb4b16";
          green = "#586e75";
          yellow = "#657b83";
          blue = "#839496";
          magenta = "#6c71c4";
          cyan = "#93a1a1";
          white = "#fdf6e3";
        };
      };
    };
  };
}
