# Treasury plugin

The Claude Code / Codex plugin for [Tempora Treasury](https://github.com/TemporaLabs/treasury) —
a savings account for an agent. The plugin is a thin wrapper: it carries the plugin manifests, the
`savings` skill, and the MCP server configuration. It never carries a key, a vault registry, or any
server code — those live in the product repo.

## What this repo will contain

- `.claude-plugin/plugin.json`, `.codex-plugin/plugin.json`, `.agents/plugins/marketplace.json` —
  the plugin manifests for each host.
- `skills/savings/SKILL.md` — the skill an agent reads.
- `.mcp.json` — points at the published `@temporalabs/treasury` package, pinned to an exact
  version.

## What it will never contain

- No server code. The MCP server ships from `@temporalabs/treasury` on npm.
- No vault registry, address, or APY. The plugin has no opinion about which vaults exist; it asks
  the running server (`savings_vaults`) at call time.
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
