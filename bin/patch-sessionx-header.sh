#!/usr/bin/env bash
# 把 tmux-sessionx 底部那行 Nerd Font 图标换成中文文案（幂等，每次 tmux 加载配置时重跑一次）
set -Eeuo pipefail

HEADER='Enter 打开 · Ctrl-r 重命名 · Alt+⌫ 删除 · Ctrl-e 新建窗口 · Ctrl-w 窗口 · Ctrl-t 树形 · Ctrl-x 配置 · Ctrl-b 返回 · Ctrl-u/d 滚动'

for f in "$HOME/.tmux/plugins/tmux-sessionx/sessionx.tmux" \
         "$HOME/.config/tmux/plugins/tmux-sessionx/sessionx.tmux"; do
  [ -f "$f" ] || continue
  if grep -qF 'HEADER="Enter 打开' "$f"; then
    echo "[ok] already patched: $f"
    continue
  fi
  if ! grep -q '^	HEADER="\$bind_accept=' "$f"; then
    echo "[!] HEADER line not found (plugin version changed?): $f" >&2
    continue
  fi
  python3 - "$f" "$HEADER" <<'PY'
import re, sys
path, header = sys.argv[1], sys.argv[2]
s = open(path, encoding="utf-8").read()
new, n = re.subn(r'^\tHEADER="\$bind_accept=.*$', '\tHEADER="%s"' % header, s, flags=re.M)
if n != 1:
    sys.exit("expected exactly one HEADER line, got %d" % n)
open(path, "w", encoding="utf-8").write(new)
PY
  echo "[ok] patched: $f"
done
