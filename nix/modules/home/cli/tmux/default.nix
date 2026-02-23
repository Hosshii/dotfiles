{
  programs.tmux = {
    enable = true;
    prefix = "C-j";
    mouse = true;
    escapeTime = 0;
    baseIndex = 1;

    extraConfig = ''
      set-option -g renumber-windows on   # ウィンドウを閉じた時に番号を詰める

      #  Prefix + vim のキーバインドでペインを移動する
      bind -r h select-pane -L
      bind -r j select-pane -D
      bind -r k select-pane -U
      bind -r l select-pane -R

      # 設定ファイルをリロード
      bind-key -T prefix r source-file ~/.config/tmux/tmux.conf \; display-message 'Reload was successful.'

      bind ";" split-window -h -c '#{pane_current_path}'    # Prefix + ; でペインを垂直分割する
      bind - split-window -v -c '#{pane_current_path}'    # Prefix + - でペインを水平分割する

      # マウスで上下移動
      bind-key -T edit-mode-vi WheelUpPane send-keys -X scroll-up
      bind-key -T edit-mode-vi WheelDownPane send-keys -X scroll-down
    '';
  };
}
