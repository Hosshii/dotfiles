{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;

    profiles.default = {
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;

      # バグでプロファイル内に設定できない
      # https://github.com/nix-community/home-manager/issues/7880
      extensions = with pkgs.vscode-extensions; [
        donjayamanne.githistory
        jnoortheen.nix-ide
        mhutchie.git-graph
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-containers
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-ssh-edit
        ms-vscode.remote-explorer
        redhat.vscode-yaml
        rust-lang.rust-analyzer
        streetsidesoftware.code-spell-checker
        tamasfe.even-better-toml
        vscodevim.vim
      ];

      # バグでファイルを設定できない　
      # https://github.com/nix-community/home-manager/issues/7726
      userSettings = {
        "claudeCode.preferredLocation" = "panel";
        "diffEditor.ignoreTrimWhitespace" = false;
        "editor.acceptSuggestionOnEnter" = "on";
        "editor.copyWithSyntaxHighlighting" = false;
        "editor.fontFamily" = "HackGen35 Console NF";
        "editor.fontSize" = 13;
        "editor.formatOnSave" = true;
        "editor.minimap.enabled" = false;
        "editor.renderWhitespace" = "boundary";
        "editor.suggestSelection" = "first";
        "editor.wordWrap" = "on";
        "files.autoSave" = "onFocusChange";
        "files.insertFinalNewline" = true;
        "git.openRepositoryInParentFolders" = "always";
        "lean4.alwaysAskBeforeInstallingLeanVersions" = true;
        "redhat.telemetry.enabled" = false;
        "remote.autoForwardPortsSource" = "hybrid";
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "terminal.integrated.defaultProfile.osx" = "zsh";
        "terminal.integrated.fontSize" = 13;
        "terminal.integrated.macOptionIsMeta" = true;
        "terminal.integrated.shellIntegration.enabled" = false;
        "terminal.integrated.profiles.linux" = {
          "bash" = {
            "path" = "${pkgs.bash}/bin/bash";
            "icon" = "terminal-bash";
          };
          "zsh" = {
            "path" = "${pkgs.zsh}/bin/zsh";
          };
          "fish" = {
            "path" = "fish";
          };
          "tmux" = {
            "path" = "tmux";
            "icon" = "terminal-tmux";
          };
          "pwsh" = {
            "path" = "pwsh";
            "icon" = "terminal-powershell";
          };
        };
        "workbench.settings.useSplitJSON" = true;

        # vscode vim
        "vim.useSystemClipboard" = true;
        "vim.hlsearch" = true;
        "vim.easymotion" = true;
        "vim.visualstar" = true;
        "vim.useCtrlKeys" = true;
        "vim.ignorecase" = true;
        "vim.incsearch" = true;

        # rust
        "[rust]" = {
          "editor.defaultFormatter" = "rust-lang.rust-analyzer";
          "editor.formatOnSave" = true;
        };
        "rust-analyzer.check.command" = "clippy";
        "yaml.format.singleQuote" = true;

        # html
        "[html]" = {
          "editor.tabSize" = 2;
          "editor.insertSpaces" = true;
          "editor.formatOnSave" = true;
          "editor.detectIndentation" = false;
        };
        "html.format.enable" = true;

        # go
        "[go]" = {
          "editor.tabSize" = 4;
          "editor.insertSpaces" = false;
          "editor.formatOnSave" = true;
          "editor.formatOnPaste" = false;
          "editor.formatOnType" = false;
        };
        "go.alternateTools" = {
          "go" = "\${env:HOME}/.local/share/mise/shims/go";
        };

        # typescript
        "[typescript]" = {
          "editor.defaultFormatter" = "biomejs.biome";
        };
        "[typescriptreact]" = {
          "editor.defaultFormatter" = "biomejs.biome";
        };
      };
    };
  };
}
