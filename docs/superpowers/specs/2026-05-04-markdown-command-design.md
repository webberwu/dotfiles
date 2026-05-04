# markdown 指令設計文件

**日期：** 2026-05-04

## 目的

一支 CLI 指令 `markdown`，用來以 Google Chrome 開啟 Markdown 檔案。Chrome 的 Markdown Reader extension 負責渲染，本地端無需進行格式轉換。

## 檔案資訊

- **路徑：** `bin/markdown`
- **無副檔名** — 與 `bin/` 下現有腳本風格一致
- **Shebang：** `#!/usr/bin/env bash`

## 支援的副檔名

`.md`、`.markdown`、`.mdown`、`.mkd`

## 行為

### 正常流程

```
markdown path/to/file.md
```

執行 `open -a "Google Chrome" "$1"` 後以 exit 0 結束。

### 錯誤情況（所有錯誤訊息輸出至 stderr，exit 1）

| 情況 | 訊息 |
|---|---|
| 未提供參數 | `Usage: markdown <file>` |
| 檔案不存在 | `Error: '<file>': no such file` |
| 副檔名不符 | `Error: '<file>': not a markdown file (.md, .markdown, .mdown, .mkd)` |

## 實作細節

副檔名以 `${1##*.}` 擷取並加上 `.` 前綴進行比對，驗證邏輯使用 `case` 陳述式以確保可讀性：

```
case ".$ext" in
  .md|.markdown|.mdown|.mkd) open ... ;;
  *) error ;;
esac
```

驗證順序：參數數量 → 檔案存在 → 副檔名格式。
