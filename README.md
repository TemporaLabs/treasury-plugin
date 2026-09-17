# Agent Treasury

**Treasury management plugin for AI agents.** By Tempora Labs.

The Claude Code / Codex plugin for [Agent Treasury](https://github.com/TemporaLabs/treasury). The
plugin is a thin wrapper: it will carry the plugin manifests, the **Earn** skill (`earn`), and the
MCP server this tree bundles. It never carries a key, and its vault registry is a snapshot — the
product repository is the authoritative source for which vaults exist.

These are experimental, yield-bearing vault positions, not bank savings accounts: returns are
variable, capital is at risk, and a withdrawal depends on the liquidity available when it is made.

## What this repository will contain

- `.claude-plugin/plugin.json`, `.codex-plugin/plugin.json`, `.agents/plugins/marketplace.json` —
  the plugin manifests for each host.
- `skills/earn/SKILL.md` — the skill an agent reads.
- `.mcp.json` — points at the published `@temporalabs/treasury` package, pinned to an exact
  version.

## What it will never contain

- No server code. The MCP server ships from `@temporalabs/treasury` on npm.
- No vault registry, address, or APY. The plugin has no opinion about which vaults exist; it asks
  the running server (`earn_vaults`) at call time.
- No key, no signer, no send path. Nothing here ever holds funds or credentials.

## Install

The plugin is installed from the product repository,
[TemporaLabs/treasury](https://github.com/TemporaLabs/treasury). This repository becomes the
install source once `@temporalabs/treasury` is published to npm.

## Docs, security, contributing

All of that lives in the product repository:
[TemporaLabs/treasury](https://github.com/TemporaLabs/treasury).

## Licence

Apache License, Version 2.0 — see [`LICENSE`](LICENSE). The Tempora names and marks are not
licensed under it.
