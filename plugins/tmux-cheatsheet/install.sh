#!/usr/bin/env bash
# 手动安装（不用 TPM）：把本目录挂到 ~/.tmux.conf
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF="${TMUX_CONF:-$HOME/.tmux.conf}"
LINE="run-shell \"$DIR/tmux-cheatsheet.tmux\""

if grep -qF "tmux-cheatsheet.tmux" "$CONF" 2>/dev/null; then
  echo "已经安装过了：$CONF 里已有 tmux-cheatsheet"
else
  [ -f "$CONF" ] && cp "$CONF" "$CONF.bak.$(date +%Y%m%d%H%M%S)"
  {
    echo ""
    echo "# tmux-cheatsheet —— 快捷键速查（prefix + ?）"
    echo "$LINE"
  } >> "$CONF"
  echo "已写入：$CONF"
fi

chmod +x "$DIR/scripts/cheatsheet.sh" "$DIR/tmux-cheatsheet.tmux" 2>/dev/null || true

if tmux info >/dev/null 2>&1; then
  tmux source-file "$CONF" && echo "已重载 tmux 配置"
fi

echo "完成：在 tmux 里按  prefix + ?  试试"
