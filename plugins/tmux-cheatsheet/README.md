# tmux-cheatsheet

按 `prefix + ?` 弹出一个**可搜索**的 tmux 快捷键速查浮窗。数据来自三处，优先级从高到低：

```
~/.tmux.conf 里 bind 上一行的 #@ 注释   ← 想改文案就改这里
        ↓
data/keymap.json 的文案表               ← 没写注释的键在这里查
        ↓
tmux list-keys 实时绑定                 ← 兜底，新加的键不会漏
```

## 安装

### 方式一：TPM（推荐）

`~/.tmux.conf`：

```tmux
set -g @plugin 'Mercizzy/customvim'

# 可选配置
set -g @cheatsheet-key '?'        # 换绑键，默认 ?
set -g @cheatsheet-width '90%'
set -g @cheatsheet-height '80%'
```

保存后按 `prefix + I` 安装。

### 方式二：手动 clone

```bash
git clone https://github.com/Mercizzy/customvim.git ~/customvim
~/customvim/plugins/tmux-cheatsheet/install.sh
```

`install.sh` 会往 `~/.tmux.conf` 追加一行 `run-shell .../tmux-cheatsheet.tmux` 并重载配置。

## 依赖

- tmux ≥ 3.2（用到 `display-popup`；3.3+ 支持圆角边框）
- `python3`
- `fzf`（可选：没有就退化成直接打印列表）

## 给某条快捷键写说明

在 `.tmux.conf` 里对应 `bind` 的**上一行**加 `#@`：

```tmux
#@ 新建窗口（保持当前目录）
bind c new-window -c "#{pane_current_path}"

#@ 项目选择器
bind f display-popup -E -w 80% -h 60% -T " 选择项目 " "$HOME/.local/bin/tmux-sessionizer"
```

改完 `prefix + r` 重载，再按 `prefix + ?` 就能看到新文案。

## 美化弹窗

插件只负责绑定和内容，外观交给 tmux 自身（3.3+）：

```tmux
set -g popup-border-lines rounded
set -g popup-border-style fg=#61AFEF,bg=#282C34
set -g popup-style fg=#ABB2BF,bg=#282C34
```

fzf 的配色已内置 One Dark，与终端、tmux 状态栏、Neovim 主题一致。

## 目录结构

```
tmux-cheatsheet/
├── tmux-cheatsheet.tmux   # 入口：读取配置并绑定 prefix + ?
├── scripts/cheatsheet.sh  # 生成列表 + fzf 展示
├── data/keymap.json       # 文案表（表名 → 键 → 说明）
├── install.sh             # 手动安装
└── README.md
```
