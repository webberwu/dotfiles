#!/usr/bin/env bash
# 在新電腦重建 Claude Code 的 user-scope plugins。
# 更新清單：跑 `claude plugin marketplace list` 與 `claude plugin list` 後手動同步下方陣列。

MARKETPLACES=(
    anthropics/claude-plugins-official
    anthropics/claude-plugins-community
    obra/superpowers-marketplace
    forrestchang/andrej-karpathy-skills
    DietrichGebert/ponytail
    nextlevelbuilder/ui-ux-pro-max-skill
    JimLiu/baoyu-skills
    ayghri/i-have-adhd
)

PLUGINS=(
    claude-md-management@claude-plugins-official
    code-review@claude-plugins-official
    commit-commands@claude-plugins-official
    context7@claude-plugins-official
    feature-dev@claude-plugins-official
    figma@claude-plugins-official
    frontend-design@claude-plugins-official
    laravel-boost@claude-plugins-official
    miro@claude-plugins-official
    notion@claude-plugins-official
    php-lsp@claude-plugins-official
    playwright@claude-plugins-official
    shopify-ai-toolkit@claude-plugins-official
    skill-creator@claude-plugins-official
    slack@claude-plugins-official
    superpowers@claude-plugins-official
    typescript-lsp@claude-plugins-official
    eli5@claude-community
    mattpocock-skills@claude-community
    andrej-karpathy-skills@karpathy-skills
    ponytail@ponytail
    ui-ux-pro-max@ui-ux-pro-max-skill
    baoyu-skills@baoyu-skills
    i-have-adhd@i-have-adhd
)

command -v claude >/dev/null || { echo "找不到 claude CLI，請先安裝 Claude Code"; exit 1; }

failed=()

echo "==> 加入 marketplaces"
for m in "${MARKETPLACES[@]}"; do
    claude plugin marketplace add "$m" || failed+=("marketplace: $m")
done

echo "==> 開啟 marketplace auto update"
# autoUpdate 只有 marketplace 層級（plugin 沒有這個開關），寫在 settings.json 的 extraKnownMarketplaces。
settings="$HOME/.claude/settings.json"
if command -v jq >/dev/null && [ -f "$settings" ]; then
    tmp=$(mktemp)
    jq '.extraKnownMarketplaces = ((.extraKnownMarketplaces // {}) | with_entries(.value.autoUpdate = true))' "$settings" > "$tmp" \
        && mv "$tmp" "$settings" \
        || { rm -f "$tmp"; failed+=("autoUpdate: settings.json 寫入失敗"); }
else
    failed+=("autoUpdate: 需要 jq 與 $settings")
fi

echo "==> 安裝 plugins (user scope)"
for p in "${PLUGINS[@]}"; do
    claude plugin install "$p" --scope user -y || failed+=("plugin: $p")
done

if [ ${#failed[@]} -gt 0 ]; then
    echo
    echo "以下項目失敗："
    printf '  - %s\n' "${failed[@]}"
    exit 1
fi

echo
echo "完成。MCP 類 plugin (notion/slack/figma/miro/context7) 仍需各自重新授權。"
echo "marketplace 已設為 auto update；claude-plugins-official 為內建，不需設定。"
