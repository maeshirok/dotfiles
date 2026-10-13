if type -q eza
    alias ll "eza -l -g --icons"
    alias lla "ll -a"
end

# fzf.fish のファイルプレビュー
if type -q bat
    set -g fzf_preview_file_cmd "bat --style=numbers --color=always --line-range :500"
end
