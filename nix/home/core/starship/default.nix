{
  custom.sheldon.plugins.starship = {
    order = 400;
    text = "inline = '''
zsh-defer -c 'eval \"$(starship init zsh)\"'
'''";
  };

  programs.starship = {
    enable = true;
    # sheldon で読み込むので有効化しない
    # enableZshIntegration = true;

    settings = {
      directory = {
        style = "blue";
      };

      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };

      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };

      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "cyan";
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
        style = "bright-black";
      };

      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
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
