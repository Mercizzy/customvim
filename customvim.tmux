#!/usr/bin/env bash
# TPM 入口：clone 整个 customvim 仓库后，由 tpm 执行本文件
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$CURRENT_DIR/plugins/tmux-cheatsheet/tmux-cheatsheet.tmux"
