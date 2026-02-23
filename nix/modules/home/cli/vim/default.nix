{
  programs.vim = {
    enable = true;
    settings = {
      number = true;
    };
    extraConfig = ''
      " 文字エンコーディング設定
      set encoding=utf-8
      set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
      set fileformats=unix,dos,mac
      
      " 文字化け対策
      set ambiwidth=double
    '';
  };
}
