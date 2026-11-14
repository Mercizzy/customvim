#!/usr/bin/env bash
# =============================================================================
# tmux-cheatsheet —— tmux 快捷键速查
#
# 数据来源（优先级从高到低）：
#   1. ~/.tmux.conf 里 bind 上一行的注释：  #@ 新建窗口
#   2. data/keymap.json（或用 $TMUX_KEYMAP_JSON 覆盖）里的文案表
#   3. tmux 当前真实的绑定（tmux list-keys），保证新增的键不会漏
#
# 用法：
#   cheatsheet.sh            # 有 fzf 就弹可搜索列表，没有就直接打印
#   cheatsheet.sh --print    # 强制直接打印（测试用）
# =============================================================================
set -euo pipefail

PRINT_ONLY=0
[ "${1:-}" = "--print" ] && PRINT_ONLY=1

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF="${TMUX_CONF:-$HOME/.tmux.conf}"
JSON="${TMUX_KEYMAP_JSON:-$HERE/../data/keymap.json}"

command -v tmux >/dev/null 2>&1 || { echo "找不到 tmux" >&2; exit 1; }

python3 - "$CONF" "$JSON" "$PRINT_ONLY" <<'PY'
import json, os, re, subprocess, sys

conf_path, json_path, print_only = sys.argv[1], sys.argv[2], sys.argv[3] == "1"

# ---------- 1. 读注释里的说明：#@ 文字 紧跟 bind ----------
comment_desc = {}
try:
    with open(os.path.expanduser(conf_path), encoding="utf-8", errors="replace") as f:
        lines = f.read().splitlines()
except OSError:
    lines = []

pending = None
for line in lines:
    stripped = line.strip()
    m = re.match(r"^#@\s+(.+)$", stripped)
    if m:
        pending = m.group(1).strip()
        continue
    if stripped.startswith("bind"):
        table, key = "prefix", None
        toks = stripped.split()
        i = 1
        while i < len(toks):
            if toks[i] == "-T" and i + 1 < len(toks):
                table = toks[i + 1]; i += 2; continue
            if toks[i].startswith("-"):
                i += 1; continue
            key = toks[i]
            break
        if key and pending:
            comment_desc[(table, key)] = pending
        pending = None
    elif stripped and not stripped.startswith("#"):
        pending = None

# ---------- 2. 读 JSON 文案表 ----------
try:
    with open(os.path.expanduser(json_path), encoding="utf-8") as f:
        table_desc = json.load(f)
except (OSError, json.JSONDecodeError):
    table_desc = {}

def desc_for(table, key):
    if (table, key) in comment_desc:
        return comment_desc[(table, key)]
    d = table_desc.get(table)
    if isinstance(d, dict) and key in d:
        return d[key]
    return ""

# ---------- 3. 读 tmux 真实绑定 ----------
def list_keys(table):
    try:
        out = subprocess.run(["tmux", "list-keys", "-T", table],
                             capture_output=True, text=True, timeout=5).stdout
    except Exception:
        return []
    items = []
    for line in out.splitlines():
        if not line.startswith("bind-key"):
            continue
        toks = line.split()
        i, tbl, repeat = 1, "prefix", ""
        while i < len(toks):
            t = toks[i]
            if t == "-T" and i + 1 < len(toks):
                tbl = toks[i + 1]; i += 2; continue
            if t == "-r":
                repeat = "  (可重复)"; i += 1; continue
            if t.startswith("-"):
                i += 1; continue
            break
        if i >= len(toks):
            continue
        key = toks[i]
        if "Mouse" in key:
            continue
        # tmux 会把特殊键转义输出，例如 \# \% \" \< ，这里还原
        if len(key) > 1 and key.startswith("\\"):
            key = key[1:]
        cmd = " ".join(toks[i + 1:])
        items.append((tbl, key, cmd, repeat))
    return items

groups = [
    ("prefix", "── Ctrl-a 之后按 ──"),
    ("root", "── 直接按（无需前缀）──"),
    ("copy-mode-vi", "── 复制模式（Ctrl-a [ 进入）──"),
]

sections = []
for table, header in groups:
    rows = []
    for tbl, key, cmd, repeat in list_keys(table):
        d = desc_for(tbl, key) or (cmd if len(cmd) <= 60 else cmd[:57] + "...")
        rows.append((key, d + repeat))
    if not rows:
        continue
    rows.sort(key=lambda r: (r[0].lower(), r[0]))
    keyw = max(len(r[0]) for r in rows)
    body = "\n".join(f"  {k:<{keyw}}   {d}" for k, d in rows)
    sections.append(header + "\n" + body)

text = "\n\n".join(sections) if sections else "tmux 还没有任何绑定"

have_fzf = subprocess.run(["bash", "-lc", "command -v fzf >/dev/null 2>&1"]).returncode == 0
if print_only or not sys.stdout.isatty() or not have_fzf:
    print(text)
    sys.exit(0)

# One Dark 配色，和终端 / tmux / nvim 保持一致
colors = (
    "--color=fg:#ABB2BF,bg:#282C34,hl:#E5C07B,fg+:#FFFFFF,bg+:#3E4451,hl+:#E5C07B,"
    "info:#98C379,prompt:#61AFEF,pointer:#E06C75,marker:#E5C07B,"
    "spinner:#56B6C2,header:#5C6370,border:#5C6370,label:#61AFEF"
)

subprocess.run(
    ["fzf", "--ansi", "--no-sort", "--height=100%", "--layout=reverse",
     "--prompt= 搜索 > ", "--pointer=▸ ", "--marker=▌",
     "--header=输入关键字过滤 · Esc 关闭", colors],
    input=text, text=True,
)
PY
