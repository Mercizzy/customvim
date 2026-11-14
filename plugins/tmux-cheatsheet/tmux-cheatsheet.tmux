#!/usr/bin/env bash
# =============================================================================
# tmux-cheatsheet —— tmux 快捷键速查浮窗（可搜索）
#
# 独立的 TPM 插件入口：
#   set -g @plugin 'Mercizzy/customvim'   # 或本地 clone 后 run-shell
#   set -g @cheatsheet-key '?'            # 可选：改成别的键
#
# 手动安装（不用 TPM）：
#   把本目录放到任意位置，然后在 ~/.tmux.conf 里加：
#   run-shell "/path/to/tmux-cheatsheet/tmux-cheatsheet.tmux"
# =============================================================================
set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

key=$(tmux show-option -gqv "@cheatsheet-key")
[ -z "$key" ] && key='?'

width=$(tmux show-option -gqv "@cheatsheet-width")
[ -z "$width" ] && width='90%'

height=$(tmux show-option -gqv "@cheatsheet-height")
[ -z "$height" ] && height='80%'

# 弹窗外观走 tmux 3.3+ 的 popup 样式（用户可在 .tmux.conf 里覆盖）
border=$(tmux show-option -gqv "popup-border-lines")

tmux bind-key "$key" display-popup -E -w "$width" -h "$height" -T " 快捷键 " \
  "$CURRENT_DIR/scripts/cheatsheet.sh"
