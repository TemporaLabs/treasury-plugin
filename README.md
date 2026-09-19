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
  and the vault registry it reads. `@temporalabs/treasury` is published to npm, and this repository
  still carries the bundle on purpose: the carried file installs nothing, while resolving the package
  by name would pull the library's runtime dependencies — on the order of a hundred packages the MCP
  server never loads. The release tag pins the version. Byte-identity between this bundle and the
  product's release is the invariant; the cross-repository check for it is tracked in #7.

## What it never contains

- No server source. Server logic is built in the product repository; this repository only carries
  the built bundle, byte-identical to the product's own.
- No key, no signer, no send path. Nothing here ever holds funds or credentials.
- No vendor call, no yield-rate source. The bundled server calls the RPC you configure and nothing
  else — no analytics, no yield API, no vendor. It quotes no rate; a position's accrued yield comes
  only from the vault's own on-chain events.

## Install

Pin to a release tag. A tag is immutable, so the install cannot drift:

```sh
claude plugin marketplace add TemporaLabs/treasury-plugin@v0.1.0
claude plugin install treasury@treasury
```

Before a release is tagged, pin its release branch instead:

```sh
claude plugin marketplace add TemporaLabs/treasury-plugin@release/v0.1.0
claude plugin install treasury@treasury
```

The `@<ref>` suffix takes any tag or branch, and `#<ref>` is equivalent. The ref is recorded with the
marketplace entry, so `claude plugin marketplace update` refreshes *that* ref rather than moving the
install onto another branch. To track the default branch instead, drop the suffix:

```sh
claude plugin marketplace add TemporaLabs/treasury-plugin
claude plugin install treasury@treasury
```

There is nothing to build and no dependency to install — the MCP server ships as a committed bundle
and runs under `node`. **Node.js 22 or later must be on `PATH`** — without it the server process
fails to spawn, and Claude Code reports that as a bare `CONNECTION_CLOSED` on any `earn_*` call,
with no mention of Node.

**Restart your Claude Code session once after installing** (or after changing the marketplace ref).
MCP servers connect only at session start — `/reload-plugins` explicitly excludes them — so the
`earn_*` tools stay absent until the next session, which otherwise looks identical to an install
failure.

Before first use, point it at a Base RPC endpoint with `TREASURY_RPC_BASE`;
[`skills/earn/SKILL.md`](skills/earn/SKILL.md) covers that and the optional
`TREASURY_LOGS_RPC_BASE`.

## Docs, security, contributing

All of that lives in the product repository:
[TemporaLabs/treasury](https://github.com/TemporaLabs/treasury). This repository's own
[`SECURITY.md`](SECURITY.md) and [`CONTRIBUTING.md`](CONTRIBUTING.md) cover the manifests and the
skill specifically.

## Licence

Apache License, Version 2.0 — see [`LICENSE`](LICENSE). The Tempora names and marks are not licensed
(section 6): a fork may say it is based on Agent Treasury; it may not present itself as the official
distribution.
