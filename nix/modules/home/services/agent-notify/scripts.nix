{ pkgs }:
let
  mkNotifyScript =
    { name
    , baseTitle
    , defaultMessage ? "通知"
    , defaultType ? "default"
    , includeTypeInTitle ? true
    ,
    }:
    pkgs.writeShellScriptBin name ''
      set -euo pipefail

      base_title="${baseTitle}"
      default_message="${defaultMessage}"
      default_type="${defaultType}"
      include_type="${if includeTypeInTitle then "1" else "0"}"

      payload="$(cat || true)"
      message="$default_message"
      notification_type="$default_type"

      if [ -n "$payload" ] && printf '%s' "$payload" | jq -e . >/dev/null 2>&1; then
        message="$(printf '%s' "$payload" | jq -r --arg default_message "$default_message" '.message // .text // .content // .summary // .output // $default_message')"
        notification_type="$(printf '%s' "$payload" | jq -r --arg default_type "$default_type" '.notification_type // .type // .event // $default_type')"
      elif [ -n "$payload" ]; then
        message="$payload"
      fi

      if [ -z "$notification_type" ] || [ "$notification_type" = "null" ]; then
        notification_type="$default_type"
      fi

      if [ "$include_type" = "1" ]; then
        title="$base_title $notification_type"
      else
        title="$base_title"
      fi

      if [ -n "''${SSH_CONNECTION:-}" ] || [ -n "''${SSH_TTY:-}" ]; then
        exec macos-remote notify "$title" "$message" --sound "$notification_type"
      fi

      exec terminal-notifier -title "$title" -message "$message" -sound "$notification_type"
    '';

  claudeNotify = mkNotifyScript {
    name = "claude_notify.sh";
    baseTitle = "Claude Code";
    defaultType = "default";
  };
  claudeStop = mkNotifyScript {
    name = "claude_stop.sh";
    baseTitle = "Claude Code Stop";
    defaultMessage = "Claude Code stopped";
    defaultType = "default";
    includeTypeInTitle = false;
  };
  codexNotify = mkNotifyScript {
    name = "codex_notify.sh";
    baseTitle = "Codex";
    defaultType = "default";
  };
in
{
  inherit claudeNotify claudeStop codexNotify;
  claudeNotifyPath = "${claudeNotify}/bin/claude_notify.sh";
  claudeStopPath = "${claudeStop}/bin/claude_stop.sh";
  codexNotifyPath = "${codexNotify}/bin/codex_notify.sh";
}
