# Agent Treasury

**Treasury management plugin for AI agents.** By Tempora Labs.

The Claude Code / Codex plugin for [Agent Treasury](https://github.com/TemporaLabs/treasury). The
plugin is a thin wrapper: it will carry the plugin manifests, the **Earn** skill (`earn`), and the
MCP server this tree bundles. It never carries a key, and its vault registry will be a snapshot —
the product repository is the authoritative source for which vaults exist.

These are experimental, yield-bearing vault positions, not bank savings accounts: returns are
variable, capital is at risk, and a withdrawal depends on the liquidity available when it is made.

## What this repository will contain

- `.claude-plugin/plugin.json`, `.codex-plugin/plugin.json`, `.agents/plugins/marketplace.json` —
  the plugin manifests for each host.
- `skills/earn/SKILL.md` — the skill an agent reads.
- `.mcp.json`, `dist/mcp-server.mjs`, `registry/vaults.json` — the MCP server this tree bundles,
  and the vault registry it reads.

## What it will never contain

- No server source. Server logic is built in the product repository; this repository will only
  carry the built bundle, byte-identical to the product's own.
- No key, no signer, no send path. Nothing here ever holds funds or credentials.

## Install

Not yet — this repository does not carry the plugin's manifests today. Once it does, it is the
install source: `claude plugin marketplace add TemporaLabs/treasury-plugin`, then
`claude plugin install treasury@treasury`.

## Docs, security, contributing

All of that lives in the product repository:
[TemporaLabs/treasury](https://github.com/TemporaLabs/treasury).

## Licence

Apache License, Version 2.0 — see [`LICENSE`](LICENSE). The Tempora names and marks are not
licensed under it.
