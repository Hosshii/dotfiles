{ config, lib, ... }:
let
  cfg = config.custom.starship;
  themes = import ./themes.nix;
  themeColors = themes.terminal // themes.${cfg.theme};
  colors = cfg.colors;
in
{
  #   custom.sheldon.plugins.starship = {
  #     order = 400;
  #     text = "inline = '''
  # zsh-defer -c 'eval \"$(starship init zsh)\"'
  # '''";
  #   };

  options.custom.starship = {
    theme = lib.mkOption {
      type = lib.types.enum (builtins.attrNames themes);
      default = "terminal";
      description = "Starship color theme.";
    };

    colors = lib.mkOption {
      type = lib.types.submodule {
        options = lib.mapAttrs
          (name: _: lib.mkOption {
            type = lib.types.str;
            default = themeColors.${name};
            description = "Starship color for ${name}. Accepts a named, indexed, or hex color.";
          })
          themes.terminal;
      };
      default = { };
      description = "Color overrides for the selected Starship theme.";
    };
  };

  config.programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      directory = {
        style = colors.directory;
      };

      character = {
        success_symbol = "[❯](${colors.success})";
        error_symbol = "[❯](${colors.error})";
        vimcmd_symbol = "[❮](${colors.vimCommand})";
      };

      git_branch = {
        format = "[$branch]($style)";
        style = colors.gitBranch;
      };

      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](${colors.gitDirty}) ($ahead_behind$stashed)]($style)";
        style = colors.gitStatus;
        conflicted = "";
        # U+200B (ゼロ幅スペース): 変更ありを示すが文字表示はしない。
        # format 側の * だけで変更有無を表現するため、各項目は空でなく
        # ゼロ幅スペースを設定して「存在するが見えない」状態にしている。
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };

      git_state = {
        format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
        style = colors.gitState;
      };

      cmd_duration = {
        format = "[$duration]($style) ";
        style = colors.commandDuration;
      };

      rust = {
        format = "[$symbol($version )]($style)";
      };

      python = {
        disabled = true;
      };

      gradle = {
        disabled = true;
      };

      java = {
        disabled = true;
      };

      kotlin = {
        disabled = true;
      };

      package = {
        disabled = true;
      };
    };
  };
}
