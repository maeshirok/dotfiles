#!/usr/bin/env bash
# fish のプロンプト Tide の設定を再現する
#
# Tide の設定は fish の universal 変数(fish_variables)に保存されます。
# fish_variables は環境ごとの値が入るため Git 管理しないので、
# 設定内容をこのスクリプトに記録しています。
#
# 事前に Tide を導入しておくこと: fisher update(fish_plugins から復元)

set -euo pipefail

FISH=/opt/homebrew/bin/fish

"$FISH" -c "tide configure --auto \
  --style=Rainbow \
  --prompt_colors='True color' \
  --show_time='24-hour format' \
  --rainbow_prompt_separators=Angled \
  --powerline_prompt_heads=Sharp \
  --powerline_prompt_tails=Flat \
  --powerline_prompt_style='One line' \
  --prompt_spacing=Compact \
  --icons='Many icons' \
  --transient=No"
