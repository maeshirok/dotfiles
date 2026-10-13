# dotfiles

macOS のターミナル環境(Ghostty、fish + Tide、tmux、mise、nvim(LazyVim)、lazygit、delta)の設定です。

参考: [craftzdog/dotfiles](https://github.com/craftzdog/dotfiles)
(個人のキー設定やショートカット、独自エイリアスは取り込んでいません)

> 公開リポジトリです。機密情報(鍵、トークン、`.env` など)は `.gitignore` で除外しています。
> 氏名・メールアドレスを含む `~/.gitconfig` は管理していません。

各ツールの基本的な使い方は [docs/usage.md](docs/usage.md) を参照してください。

## 構成

```
Brewfile                      Homebrew のパッケージ一覧
docs/usage.md                 各ツールの基本操作メモ
scripts/sync.sh               設定の反映・取り込み(コピー方式)
scripts/setup-tide.sh         fish のプロンプト Tide の設定
.config/ghostty/              Ghostty
.config/fish/                 fish(config.fish、config-osx.fish、fish_plugins)
.config/tmux/                 tmux
.config/mise/                 mise(node、ghq)
.config/lazygit/              lazygit(macOS では Library/Application Support/lazygit に反映)
.config/git/                  git(delta の設定と共通設定)
.config/nvim/                 nvim(LazyVim スターター + Solarized Osaka)
```

## セットアップ

```sh
git clone git@github.com:maeshirok/dotfiles.git ~/Github/my-repository/dotfiles
cd ~/Github/my-repository/dotfiles

# 1. パッケージの導入
brew bundle --file=Brewfile

# 2. fish のプラグイン管理(Fisher)の導入
fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'

# 3. tmux のプラグイン管理(tpm)
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# 4. 設定の反映(上書き前に ~/.dotfiles-backup/ へ退避されます)
./scripts/sync.sh deploy

# 5. プラグインの復元と各ツールの準備
fish -c 'fisher update'                          # fish_plugins から Tide、fzf.fish を復元
./scripts/setup-tide.sh                          # Tide の見た目を設定
~/.config/tmux/plugins/tpm/bin/install_plugins   # tmux-sensible
mise install                                     # node、ghq
nvim                                             # 初回起動でプラグインが入る
```

Ghostty を再起動すると、fish が起動します。ログインシェル(zsh)は変更していません。
元に戻すには、`.config/ghostty/config` の `command = ...` の行を削除します。

## 運用

設定はホーム側(`~/.config/...`)を編集して使い、変更をリポジトリへ取り込みます(コピー方式)。

```sh
./scripts/sync.sh diff      # リポジトリとホームの差分を確認
./scripts/sync.sh collect   # ホーム -> リポジトリ へ取り込む
git status && git diff      # 内容を確認(機密情報が無いこと)
git add -A && git commit -m "..." && git push
```

別の環境では `./scripts/sync.sh deploy` で反映します。

## 取り込んでいないもの

- craftzdog 個人のキー設定(tmux の prefix `C-t`、独自キーバインド、nvim の独自キーマップなど)
- 独自のエイリアス、lazygit の commitizen 連携
- tmux-pain-control プラグイン(慣れてから追加できます)
