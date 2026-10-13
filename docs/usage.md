# 各ツールの基本操作メモ

最初に覚えると便利な操作をまとめています。詳しくは各ツールの公式ドキュメントを参照してください。

## Ghostty(ターミナル)

| 操作 | キー |
| --- | --- |
| 新しいタブ | `Cmd + T` |
| 新しいウィンドウ | `Cmd + N` |
| 画面を左右に分割 | `Cmd + D` |
| 画面を上下に分割 | `Cmd + Shift + D` |
| 分割間の移動 | `Cmd + [` / `Cmd + ]` |
| 閉じる | `Cmd + W` |
| 設定の再読み込み | `Cmd + Shift + ,` |

- 設定ファイル: `~/.config/ghostty/config`
- 左 Option キーは Alt として動作します(tmux や nvim で使う Alt 系のキーのため)。

## fish(シェル)

- 履歴から候補が薄く表示されます。`→`(右矢印)で確定できます。
- `Tab` で補完します。
- `fzf.fish` のキー(Ctrl + Option は Ghostty では Ctrl + Alt として動作します)
  - `Ctrl + R`: コマンド履歴を検索
  - `Ctrl + Alt + F`: ファイルを検索
  - `Ctrl + Alt + L`: git のログを検索
  - `Ctrl + Alt + S`: git の変更ファイルを検索
- `z <ディレクトリ名の一部>`(zoxide): よく行くディレクトリへ移動。`zi` で一覧から選択
- `ls` / `ll` / `lla`: eza によるアイコン付きの一覧(`ll`、`lla`)
- プロンプト(Tide)の見た目を変える: `tide configure`(対話式)。再現用の設定は `scripts/setup-tide.sh`
- プラグイン: `fisher list`、`fisher install <name>`、`fisher update`(一覧は `fish_plugins`)
- 手元だけの設定(秘密情報など)は `~/.config/fish/config-local.fish` に書きます(Git 管理されません)。

## tmux(ターミナルの分割・セッション管理)

prefix キーは標準の `Ctrl + B` です。以下は「prefix を押して、離してから」入力します。

| 操作 | キー |
| --- | --- |
| 新しいウィンドウ | `prefix` → `c` |
| ウィンドウの切り替え | `prefix` → `n`(次)/ `p`(前)/ 数字(1 から始まります) |
| ウィンドウ名の変更 | `prefix` → `,` |
| 画面を左右に分割 | `prefix` → `%` |
| 画面を上下に分割 | `prefix` → `"` |
| ペインの移動 | `prefix` → 矢印キー |
| ペインを閉じる | `exit`、または `prefix` → `x` |
| セッションから離脱(裏で動かし続ける) | `prefix` → `d` |
| コピーモード(スクロール) | `prefix` → `[`(終了は `q`) |
| プラグインの導入 | `prefix` → `Shift + I`(tpm) |
| 設定の再読み込み | `prefix` → `Shift + R`(tmux-sensible) |

- コマンド: `tmux` / `tmux new -s <名前>` / `tmux ls` / `tmux attach -t <名前>`
- マウスが有効です(ペインのクリック、スクロール、境界線のドラッグ)。
- 設定ファイル: `~/.config/tmux/tmux.conf`(再読み込みは `tmux source ~/.config/tmux/tmux.conf`)
- プラグイン: tpm と tmux-sensible(一般的な推奨設定)

## nvim(エディタ・LazyVim)

- 起動: `nvim <ファイル>`、`vim` でも起動します(エイリアス)
- 基本の操作(Vim): `i` で入力、`Esc` で戻る、`:w` 保存、`:q` 終了、`:wq` 保存して終了
- LazyVim のリーダーキーは `Space` です。押して少し待つと、使えるキーの一覧が出ます(which-key)。
  - `Space` `Space`: ファイルを検索
  - `Space` `/`: 文字列を検索(ripgrep)
  - `Space` `e`: ファイルツリー
  - `Space` `g` `g`: lazygit を開く
- コマンド
  - `:Lazy`: プラグインの管理
  - `:Mason`: 言語サーバ(補完や診断)の管理
  - `:LazyExtras`: 言語ごとの追加設定
  - `:checkhealth`: 環境の診断
- 設定ファイル: `~/.config/nvim/`(`lua/plugins/` にファイルを追加すると設定を増やせます)
- テーマ: Solarized Osaka(透過)

## lazygit(Git の操作画面)

- Git リポジトリの中で `lazygit` を実行します。
- `?`: キー操作の一覧、`q`: 終了
- ファイル画面: `Space` で追加(ステージ)、`c` でコミット、`P` でプッシュ、`p` でプル
- マウスは無効にしています(`~/Library/Application Support/lazygit/config.yml`)。

## git と delta

- `git diff`、`git log -p`、`git show` の差分が、delta で見やすく表示されます(行番号、色)。
- 共通設定(`.config/git/common.gitconfig`): デフォルトのブランチ名は `main`、初回プッシュ時にリモートを自動設定、エディタは nvim、コンフリクト表示は zdiff3
- 氏名・メールアドレスは `~/.gitconfig` に残してあります(Git 管理していません)。

## mise(ツールのバージョン管理)

- `mise ls`: 導入済みのツールを表示
- `mise install`: `~/.config/mise/config.toml` に書かれたツール(node、ghq)を導入
- `mise use -g node@lts`: node を LTS 版に切り替える(グローバル)
- `mise ls-remote node`: 導入できるバージョンの一覧
- fish の中では、mise の node が Homebrew の node より優先されます。

## ghq(リポジトリ管理)

- `ghq get <リポジトリの URL>`: `~/ghq/github.com/<ユーザー>/<リポジトリ>` へ取得
- `ghq list`: 取得済みのリポジトリの一覧
- `ghq root`: 保存先(標準は `~/ghq`)
- 既存の `~/Github/my-repository/` 配下のリポジトリは移動していません。

## この dotfiles の運用

[README.md](../README.md) を参照してください(`scripts/sync.sh` で反映・取り込み)。
