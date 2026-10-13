set fish_greeting ""

# Homebrew
# Ghostty は zsh の .zprofile を経由しないため、fish 側で PATH を設定する
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv fish | source
end

# エディタ
set -gx EDITOR nvim
command -qv nvim && alias vim nvim

# 基本のエイリアス
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"

# PATH
fish_add_path -g ~/.local/bin

# Go
set -gx GOPATH $HOME/go
fish_add_path -g $GOPATH/bin

# OS ごとの設定
switch (uname)
    case Darwin
        set -l osx_config (dirname (status --current-filename))/config-osx.fish
        test -f $osx_config && source $osx_config
end

# ツールの初期化(未導入ならスキップ)
if status is-interactive
    type -q mise && mise activate fish | source
    type -q zoxide && zoxide init fish | source
end

# 手元だけの設定(Git 管理しない。秘密情報はここに書く)
set -l local_config (dirname (status --current-filename))/config-local.fish
test -f $local_config && source $local_config
