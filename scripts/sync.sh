#!/usr/bin/env bash
# dotfiles の同期スクリプト(コピー方式)
#
#   ./scripts/sync.sh deploy   リポジトリ -> ホーム へ反映する(上書き前に退避)
#   ./scripts/sync.sh collect  ホーム -> リポジトリ へ取り込む
#   ./scripts/sync.sh diff     リポジトリとホームの差分を表示する
#
# 管理対象は下の ENTRIES に書いたものだけです(ホーム全体は扱いません)。
# macOS 標準の bash 3.2 でも動くように書いています。

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# 管理対象: "リポジトリ内のパス|ホーム内のパス"(末尾が / のものはディレクトリ)
ENTRIES=(
  ".config/ghostty/config|.config/ghostty/config"
  ".config/fish/config.fish|.config/fish/config.fish"
  ".config/fish/config-osx.fish|.config/fish/config-osx.fish"
  ".config/fish/fish_plugins|.config/fish/fish_plugins"
  ".config/tmux/tmux.conf|.config/tmux/tmux.conf"
  ".config/tmux/macos.conf|.config/tmux/macos.conf"
  ".config/tmux/theme.conf|.config/tmux/theme.conf"
  ".config/tmux/statusline.conf|.config/tmux/statusline.conf"
  ".config/mise/config.toml|.config/mise/config.toml"
  ".config/lazygit/config.yml|Library/Application Support/lazygit/config.yml"
  ".config/git/delta.gitconfig|.config/git/delta.gitconfig"
  ".config/git/common.gitconfig|.config/git/common.gitconfig"
  ".config/nvim/|.config/nvim/"
)

# ~/.gitconfig から include するファイル(氏名・メールアドレスは ~/.gitconfig に残す)
GIT_INCLUDES=(
  "~/.config/git/common.gitconfig"
  "~/.config/git/delta.gitconfig"
)

RSYNC_EXCLUDES=(--exclude=.git --exclude=.DS_Store)
DIFF_EXCLUDES=(-x .git -x .DS_Store)

backup() {
  # $1: 退避するパス(ホーム内の絶対パス)
  local target="$1"
  [ -e "$target" ] || return 0
  local rel="${target#$HOME/}"
  mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
  cp -R "$target" "$BACKUP_DIR/$rel"
  echo "  退避: $rel -> $BACKUP_DIR"
}

same() {
  # $1, $2: 比較する 2 つのパス(ファイルまたはディレクトリ)
  [ -e "$1" ] && [ -e "$2" ] || return 1
  if [ -d "$1" ]; then
    diff -rq "${DIFF_EXCLUDES[@]}" "$1" "$2" >/dev/null 2>&1
  else
    cmp -s "$1" "$2"
  fi
}

split_entry() {
  repo_rel="${1%%|*}"
  home_rel="${1#*|}"
  repo_path="$REPO_DIR/$repo_rel"
  home_path="$HOME/$home_rel"
}

copy_path() {
  # $1: コピー元, $2: コピー先
  if [ -d "$1" ]; then
    mkdir -p "$2"
    rsync -a "${RSYNC_EXCLUDES[@]}" "$1" "$2"
  else
    mkdir -p "$(dirname "$2")"
    cp "$1" "$2"
  fi
}

deploy() {
  echo "== deploy: リポジトリ -> ホーム"
  local entry
  for entry in "${ENTRIES[@]}"; do
    split_entry "$entry"
    if [ ! -e "$repo_path" ]; then
      echo "  skip(リポジトリに無い): $repo_rel"
      continue
    fi
    if same "$repo_path" "$home_path"; then
      echo "  同じ: $home_rel"
      continue
    fi
    backup "${home_path%/}"
    copy_path "$repo_path" "$home_path"
    echo "  反映: $home_rel"
  done

  local inc backed_up=0
  for inc in "${GIT_INCLUDES[@]}"; do
    if git config --global --get-all include.path 2>/dev/null | grep -Fxq "$inc"; then
      echo "  同じ: ~/.gitconfig の include $inc"
    else
      if [ "$backed_up" -eq 0 ]; then
        backup "$HOME/.gitconfig"
        backed_up=1
      fi
      git config --global --add include.path "$inc"
      echo "  追記: ~/.gitconfig の include $inc"
    fi
  done
}

collect() {
  echo "== collect: ホーム -> リポジトリ"
  local entry
  for entry in "${ENTRIES[@]}"; do
    split_entry "$entry"
    if [ ! -e "$home_path" ]; then
      echo "  skip(ホームに無い): $home_rel"
      continue
    fi
    if same "$home_path" "$repo_path"; then
      echo "  同じ: $repo_rel"
      continue
    fi
    copy_path "$home_path" "$repo_path"
    echo "  取り込み: $repo_rel"
  done
  echo
  echo "取り込んだ内容を git diff / git status で確認してからコミットしてください。"
}

show_diff() {
  echo "== diff: リポジトリ <-> ホーム"
  local entry
  for entry in "${ENTRIES[@]}"; do
    split_entry "$entry"
    if [ ! -e "$home_path" ]; then
      echo "  ホームに無い: $home_rel"
    elif [ ! -e "$repo_path" ]; then
      echo "  リポジトリに無い: $repo_rel"
    elif same "$repo_path" "$home_path"; then
      echo "  同じ: $repo_rel"
    else
      echo "  違い: $repo_rel"
      diff -ru "${DIFF_EXCLUDES[@]}" "$repo_path" "$home_path" 2>/dev/null | head -20 || true
    fi
  done
}

case "${1:-}" in
  deploy)  deploy ;;
  collect) collect ;;
  diff)    show_diff ;;
  *)
    echo "使い方: $0 {deploy|collect|diff}" >&2
    exit 1
    ;;
esac
