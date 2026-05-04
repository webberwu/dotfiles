# markdown 指令實作計畫

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 在 `bin/` 下建立一支名為 `markdown` 的 shell script，驗證輸入的 markdown 檔案後以 Google Chrome 開啟。

**Architecture:** 單一 bash script，依序驗證參數數量、檔案存在、副檔名格式，通過後以 `open -a "Google Chrome"` 開啟。

**Tech Stack:** bash

---

### Task 1：建立 `bin/markdown` 並實作參數驗證

**Files:**
- Create: `bin/markdown`

- [ ] **Step 1：建立檔案，加入 shebang 與無參數檢查**

```bash
#!/usr/bin/env bash

if [[ $# -eq 0 ]]; then
  echo "Usage: markdown <file>" >&2
  exit 1
fi
```

- [ ] **Step 2：手動測試無參數情況**

執行：
```bash
bash bin/markdown
```

預期輸出（stderr）：
```
Usage: markdown <file>
```
預期 exit code：`1`（驗證：`echo $?` 輸出 `1`）

---

### Task 2：加入檔案存在驗證

**Files:**
- Modify: `bin/markdown`

- [ ] **Step 1：在參數檢查後加入檔案存在驗證**

```bash
#!/usr/bin/env bash

if [[ $# -eq 0 ]]; then
  echo "Usage: markdown <file>" >&2
  exit 1
fi

file="$1"

if [[ ! -f "$file" ]]; then
  echo "Error: '$file': no such file" >&2
  exit 1
fi
```

- [ ] **Step 2：手動測試檔案不存在的情況**

執行：
```bash
bash bin/markdown /tmp/nonexistent.md
```

預期輸出（stderr）：
```
Error: '/tmp/nonexistent.md': no such file
```
預期 exit code：`1`

---

### Task 3：加入副檔名驗證與 Chrome 開啟

**Files:**
- Modify: `bin/markdown`

- [ ] **Step 1：加入副檔名 case 驗證與 open 指令，完成完整腳本**

```bash
#!/usr/bin/env bash

if [[ $# -eq 0 ]]; then
  echo "Usage: markdown <file>" >&2
  exit 1
fi

file="$1"

if [[ ! -f "$file" ]]; then
  echo "Error: '$file': no such file" >&2
  exit 1
fi

ext=".${file##*.}"

case "$ext" in
  .md|.markdown|.mdown|.mkd)
    open -a "Google Chrome" "$file"
    ;;
  *)
    echo "Error: '$file': not a markdown file (.md, .markdown, .mdown, .mkd)" >&2
    exit 1
    ;;
esac
```

- [ ] **Step 2：手動測試非 markdown 副檔名**

```bash
touch /tmp/test.sh
bash bin/markdown /tmp/test.sh
```

預期輸出（stderr）：
```
Error: '/tmp/test.sh': not a markdown file (.md, .markdown, .mdown, .mkd)
```
預期 exit code：`1`

- [ ] **Step 3：手動測試所有支援的副檔名**

```bash
touch /tmp/test.md /tmp/test.markdown /tmp/test.mdown /tmp/test.mkd
bash bin/markdown /tmp/test.md
bash bin/markdown /tmp/test.markdown
bash bin/markdown /tmp/test.mdown
bash bin/markdown /tmp/test.mkd
```

預期：Chrome 各開啟一次，exit code 皆為 `0`。

- [ ] **Step 4：加上可執行權限**

```bash
chmod +x bin/markdown
```

- [ ] **Step 5：以可執行方式再測試一次**

```bash
./bin/markdown /tmp/test.md
```

預期：Chrome 開啟該檔案。

- [ ] **Step 6：清理暫存測試檔**

```bash
rm /tmp/test.md /tmp/test.markdown /tmp/test.mdown /tmp/test.mkd /tmp/test.sh
```

- [ ] **Step 7：Commit**

```bash
git add bin/markdown
git commit -m "feat(bin): add markdown command to open files in Chrome"
```
