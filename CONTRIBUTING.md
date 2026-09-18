# Contributing to the Agent Treasury plugin

This repository is open source under the Apache License, Version 2.0 (see
[`LICENSE`](LICENSE)). You can use, modify and redistribute it freely, and improvements are
welcome. Tempora Labs reviews every change and decides what merges.

This repository carries manifests, a skill, and a built server bundle — not server source.

## Before you open a pull request

- **Run the validator:** `bash scripts/lint-skill.sh` must pass.
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
