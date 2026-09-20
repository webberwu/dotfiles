# dotfiles

## 安裝

```bash
git clone <repo> ~/git/dotfiles
cd ~/git/dotfiles
./setup --dry-run   # 先看會連哪些檔案
./setup
```

以下功能只在 macOS 有效：

- `.claude/hooks/notify.sh`：只呼叫 `osascript`，Linux 上不會有通知（沒有 `notify-send` 分支）
- `bin/markdown:19`：`open -a "Google Chrome"`，Linux 上沒有 `open`
- `setup:52`：結尾的完成通知走 `osascript`，Linux 上失敗但已用 `|| true` 吞掉，不影響安裝

## 手動步驟

`setup` 不做這些：

**Nerd Font 字型**（prompt 與 `.tmux.theme` 的 powerline 字元要靠它）

```bash
git clone --filter=blob:none --sparse --depth=1 https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
./install.sh install DroidSansMono
./install.sh install JetBrainsMono
cd .. && rm -rf nerd-fonts
```

`install.sh` 是從 release 下載字型，不吃 repo 裡的檔案，所以淺 clone 就夠（完整 repo 有數 GB）。macOS 裝到 `~/Library/Fonts`，Linux 裝到 `~/.local/share/fonts`。

裝完在 iTerm2 Profiles → Text 設字型（GNOME Terminal 在 Profile Preferences）：

- Font：`DroidSansM Nerd Font Mono`
- Non-ASCII Font：`JetBrainsMono Nerd Font`（CJK 對齊用）

**Claude Code plugins**：新電腦重建 user-scope plugins 與 skills：

```bash
./.claude/install-plugins.sh
```

清單維護在腳本內的 `MARKETPLACES` / `PLUGINS` / `SKILLS` 陣列，用 `claude plugin marketplace list` 與 `claude plugin list` 對照更新。MCP 類 plugin（notion / slack / figma / miro / context7）仍需各自重新授權。

**git hooks**：`.git-hooks/` 會被連到 `~/.git-hooks`，但 `.gitconfig` 沒設 `core.hooksPath`，要用時自己指定：

```bash
git config --global core.hooksPath ~/.git-hooks
```
