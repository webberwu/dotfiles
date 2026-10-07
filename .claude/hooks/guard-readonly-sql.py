#!/usr/bin/env python3
"""PreToolUse(mcp__mariadb-rhitics__execute_sql)：只放行唯讀 SQL。

每個 statement 開頭必須是唯讀關鍵字，且去掉註解與字串後不得出現寫入關鍵字。
讀不到 SQL 時一律擋下（fail closed）。`--selftest` 跑內建檢查。
"""
import json
import re
import sys

READ_FIRST = {"SELECT", "SHOW", "DESC", "DESCRIBE", "EXPLAIN", "WITH", "USE"}
# REPLACE / SET 不列入：REPLACE() 函式與 CHARACTER SET 會誤擋，且它們當開頭時已被 READ_FIRST 擋下
WRITE_ANYWHERE = re.compile(
    r"\b(INSERT|UPDATE|DELETE|DROP|ALTER|TRUNCATE|CREATE|RENAME|GRANT|REVOKE|OUTFILE|DUMPFILE|LOAD_FILE)\b"
)


def reason(sql):
    if not isinstance(sql, str) or not sql.strip():
        return "讀不到 SQL"
    if re.search(r"/\*M?!", sql):  # MariaDB 可執行註解 /*! ... */ 會被當成 SQL 執行
        return "不允許可執行註解 /*! */"
    s = re.sub(r"'(?:[^'\\]|\\.)*'|\"(?:[^\"\\]|\\.)*\"", "''", sql)
    s = re.sub(r"/\*.*?\*/", " ", s, flags=re.S)
    s = re.sub(r"(--\s|#).*?$", " ", s, flags=re.M).upper()
    for stmt in filter(str.strip, s.split(";")):
        first = re.match(r"\s*\(*\s*(\w+)", stmt)
        if not first or first.group(1) not in READ_FIRST:
            return f"非唯讀語句：{stmt.strip()[:40]}"
        hit = WRITE_ANYWHERE.search(stmt)
        if hit:
            return f"含寫入關鍵字 {hit.group(1)}"
    return None


def selftest():
    ok = ["SELECT 1", "select * from t where s='delete me'", "SELECT REPLACE(a,'x','y') FROM t",
          "-- c\nSHOW TABLES", "WITH x AS (SELECT 1) SELECT * FROM x", "(SELECT 1) UNION (SELECT 2)",
          "SELECT updated_at, created_by FROM t"]
    bad = ["  delete from t", "/* c */ DELETE FROM t", "SELECT 1; DELETE FROM t", "TRUNCATE t",
           "REPLACE INTO t VALUES (1)", "CREATE TABLE t (a int)", "GRANT ALL ON *.* TO x",
           "WITH x AS (SELECT 1) DELETE FROM t", "SELECT * FROM t INTO OUTFILE '/tmp/x'",
           "SELECT 1 /*! ; DROP TABLE t */", "SELECT * FROM t FOR UPDATE", "SET @a=1", "", None]
    for q in ok:
        assert reason(q) is None, (q, reason(q))
    for q in bad:
        assert reason(q) is not None, q
    print("ok")


if __name__ == "__main__":
    if sys.argv[1:] == ["--selftest"]:
        selftest()
        sys.exit(0)
    try:
        sql = json.load(sys.stdin).get("tool_input", {}).get("sql_query")
    except Exception:
        sql = None
    r = reason(sql)
    if r:
        print(f"唯讀 DB：已阻擋（{r}）", file=sys.stderr)
        sys.exit(2)
