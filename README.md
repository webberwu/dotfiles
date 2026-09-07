## Install powerline fonts

### MacOS

```
$ git clone https://github.com/powerline/fonts.git --depth=1
$ cd fonts
$ ./install.sh
$ cd ..
$ rm -rf fonts
```

change font to "Roboto Mono for Powerline" in iTerm2.

## Claude Code plugins

新電腦重建 user-scope plugins：

```
$ ./.claude/install-plugins.sh
```

清單維護在腳本內的 `MARKETPLACES` / `PLUGINS` 陣列，用 `claude plugin list` 對照更新。
