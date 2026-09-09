# CLAUDE.md (Global)

## Research & External Data

- 查詢外部工具、函式庫或框架的資料時（GitHub stars、版本資訊、比較表），一律透過 WebFetch 從即時來源驗證，不可依賴訓練資料。
- 陳述任何技術內容前，特別是第三方套件（例如 kainxspirits/laravel-pubsub、GCP 與 AWS 事件服務），先對照實際原始碼或官方文件進行驗證。
- 進行任何技術比較（A vs B）時，每一項陳述都必須附上：(a) 來自套件原始碼的引文與 file:line，或 (b) 官方文件連結。若無法驗證，請標記 [UNVERIFIED]，不可直接陳述。

## Code Investigation

- 調查程式碼時，一律引用經驗證的 file:line 作為結論證據；追蹤實際呼叫鏈而非臆測。
- 回答 codebase 問題時，一律附上 `path/to/file.php:1265` 格式的路徑與行號。引用前必須先用 Read 或 Grep 確認該行確實存在，不確定時明確標注。
- 呈現任何說明、圖表、ELI5 或 Archify 產出前，先對照實際 codebase 逐項事實查核；每個非顯而易見的斷言都要附檔案路徑與行號。
- 明確區分「直接觀察到的證據」與「推論」，推論一律標為推論，不可混寫成事實。
- 未出示日誌／DB／程式碼證據前，不可陳述因果關係（例如「timeout X 造成失敗 Y」），只能寫成待驗證的假設。

## Analysis Mode (唯讀)

- 使用者要求分析、調查或根因追查時，該任務即為唯讀：不修改檔案、不執行 `git stash`、不安裝或移除任何東西。
- 先回報發現並提出 diff，取得明確同意後才變更任何狀態。

## Bug Fixes

- 修根因，不修症狀。
- 除非明確要求暫時性 workaround，不可用設定變更壓制或繞過錯誤（linter ignore、停用規則、try/catch 吞例外）；先確認底層工具／套件是否過舊或設定錯誤。

## File Paths

- 回報檔案位置一律用完整絕對路徑，不可用 `...` 省略目錄或截斷路徑；包含產出的 HTML/artifact 位置與暫存檔。

## External Sync (Notion / Obsidian / ClickUp 等外部服務)

- 同步到 Notion、Obsidian、ClickUp 前，任何寫入變更一律先呈現 diff，經我核准後才套用；唯讀查詢不在此限。

## Database Queries

- 查詢 DB 前，務必先評估 SQL 是否為 slow SQL；若有疑慮，執行前必須先與我確認才能執行。
- 判斷基準：過濾欄位無索引（先查 schema 確認 key 為 PRI/UNI/MUL）、無條件聚合（COUNT/MAX/MIN）、`LIKE '%...%'` 前綴萬用字元，皆視為 slow SQL 疑慮。
- 需要資料表大小或統計資訊時，用 `SHOW TABLE STATUS` 或 `information_schema`，不要 `COUNT(*)`。

## Language Preferences

除非明確要求，否則一律以繁體中文回覆。

## 本機專用

@~/.claude/CLAUDE.local.md
