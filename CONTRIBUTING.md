# Contributing to the Agent Treasury plugin

This repository is open source under the Apache License, Version 2.0 (see
[`LICENSE`](LICENSE)). You can use, modify and redistribute it freely, and improvements are
welcome. Tempora Labs reviews every change and decides what merges.

This repository carries manifests, a skill, and a built server bundle — not server source.

## Before you open a pull request

- **Run the validator:** `bash scripts/lint-skill.sh` must pass.
- **Refreshing the bundle? Move the pin in the same commit.** `dist/mcp-server.mjs`,
  `registry/vaults.json`, `NOTICE` and `THIRD_PARTY_NOTICES.md` are copies of the product's files,
  and `bundle-source.json` names the product ref they came from. `bash scripts/check-bundle-source.sh`
  fetches the product at that ref and compares byte for byte, so a refresh that leaves the pin behind
  goes red — as does a pin moved without refreshing the files. The ref must be a `vX.Y.Z` tag or a
  full 40-character commit SHA; a branch name is refused, because it moves.
- **The skill's `description:` decides whether the skill is reached at all, so treat a change to it
  as a behavioural change.** Measure it by running the plugin — `claude -p --plugin-dir <this tree>`
  from a working directory that is *not* this tree, then check which tools the run actually
  invoked. A description that reads better is not evidence of anything.
- **Keep a pull request to one change.** A documentation fix found along the way gets its own pull
  request.

## What lives here vs. the product

This repository is the thin plugin: manifests, the skill, and the MCP server bundle it points at.
Server logic, the vault registry, and the tools themselves are built in
[TemporaLabs/treasury](https://github.com/TemporaLabs/treasury). A change to what a tool does
belongs there.

## Security

Do not open a public issue for a vulnerability. See [`SECURITY.md`](SECURITY.md).
