{ pkgs }:
let
  # terminal-notifierとかもpkgs/bin/...を指定するようにしたいがそうするとlinuxでないと言われる
  claudeNotify = pkgs.writeShellScriptBin "claude_notify.sh" ''
    set -euo pipefail

    payload="''$(cat)"

    # jqで1フィールド読む。読めない/型が違う/空ならデフォルト
    jqs() { ${pkgs.jq}/bin/jq -er "$1" <<<"$payload" 2>/dev/null || printf '%s' "$2"; }

    notification_type="''$(jqs '.notification_type' 'other')"
    message="''$(jqs '(.message // .text // .content)' ''')"

    case "$notification_type" in
      stop) sound="stop" ;;
      task_complete) sound="task_complete" ;;
      permission_prompt) sound="permission_prompt" ;;
      idle_prompt) sound="idle_prompt" ;;
      elicitation_dialog) sound="elicitation_dialog" ;;
      *) sound="other" ;;
    esac

    title="Claude $notification_type"

    if [ -n "''${SSH_CONNECTION:-}" ] || [ -n "''${SSH_TTY:-}" ]; then
      exec macos-remote notify "$title" "$message" --sound "$sound"
    fi

    exec terminal-notifier -title "$title" -message "$message" -sound "$sound"
  '';

  claudeStop = pkgs.writeShellScriptBin "claude_stop.sh" ''
    set -euo pipefail

    title="Claude Code Stop"
    message="Claude Code stopped"
    sound="task_complete"

    if [ -n "''${SSH_CONNECTION:-}" ] || [ -n "''${SSH_TTY:-}" ]; then
      exec macos-remote notify "$title" "$message" --sound "$sound"
    fi

    exec terminal-notifier -title "$title" -message "$message" -sound "$sound"
  '';

  codexNotify = pkgs.writeShellScriptBin "codex_notify.sh" ''
    set -euo pipefail

    payload="''${1:-{}}"

    # jqで1フィールド読む。読めない/型が違う/空ならデフォルト
    jqs() { ${pkgs.jq}/bin/jq -er "$1" <<<"$payload" 2>/dev/null || printf '%s' "$2"; }

    notification_type="''$(jqs '.type' 'other')"
    message="''$(jqs '.message' ''')"

    case "$notification_type" in
      agent-turn-complete) sound="task_complete" ;;
      *) sound="other" ;;
    esac

    title="Codex $notification_type"

    if [ -n "''${SSH_CONNECTION:-}" ] || [ -n "''${SSH_TTY:-}" ]; then
      macos-remote notify "$title" "$message" --sound "$sound"
    fi

    exec terminal-notifier -title "$title" -message "$message" -sound "$sound"
  '';
in
{
  inherit claudeNotify claudeStop codexNotify;
  claudeNotifyPath = "${claudeNotify}/bin/claude_notify.sh";
  claudeStopPath = "${claudeStop}/bin/claude_stop.sh";
  codexNotifyPath = "${codexNotify}/bin/codex_notify.sh";
}
