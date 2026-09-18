# Agent Treasury

**Treasury management plugin for AI agents.** By Tempora Labs.

The Claude Code / Codex plugin for [Agent Treasury](https://github.com/TemporaLabs/treasury). The
plugin is a thin wrapper: it carries the plugin manifests, the **Earn** skill (`earn`), and the MCP
server and vault registry this tree bundles. It never carries a key, and the registry it ships is a
snapshot — the product repository is the authoritative source for which vaults exist.

These are experimental, yield-bearing vault positions, not bank savings accounts: returns are
variable, capital is at risk, and a withdrawal depends on the liquidity available when it is made.

## What this repository contains

- `.claude-plugin/plugin.json`, `.codex-plugin/plugin.json`, `.agents/plugins/marketplace.json` —
  the plugin manifests for each host.
- `skills/earn/SKILL.md` — the skill an agent reads.
- `.mcp.json`, `dist/mcp-server.mjs`, `registry/vaults.json` — the MCP server this tree bundles,
  and the vault registry it reads. Once `@temporalabs/treasury` is published to npm, `.mcp.json`
  moves to an exact-version `npx` pin and this repository stops carrying the bundle directly; that
  is the intended order, not a change of plan.

## What it never contains

- No server source. Server logic is built in the product repository; this repository only carries
  the built bundle, byte-identical to the product's own.
- No key, no signer, no send path. Nothing here ever holds funds or credentials.
- No vendor call, no yield-rate source. The bundled server calls the RPC you configure and nothing
  else — no analytics, no yield API, no vendor. It quotes no rate; a position's accrued yield comes
  only from the vault's own on-chain events.

## Install

`claude plugin marketplace add TemporaLabs/treasury-plugin`, then
`claude plugin install treasury@treasury`.

## Docs, security, contributing

All of that lives in the product repository:
[TemporaLabs/treasury](https://github.com/TemporaLabs/treasury). This repository's own
[`SECURITY.md`](SECURITY.md) and [`CONTRIBUTING.md`](CONTRIBUTING.md) cover the manifests and the
skill specifically.

## Licence

Apache License, Version 2.0 — see [`LICENSE`](LICENSE). The Tempora names and marks are not licensed
(section 6): a fork may say it is based on Agent Treasury; it may not present itself as the official
distribution.
