# AGENTS.md

Instructions for coding agents working in this repository. People should start with
[`CONTRIBUTING.md`](CONTRIBUTING.md); it wins if the two ever disagree.

This is the thin plugin for Agent Treasury: marketplace and plugin manifests (`.claude-plugin/`,
`.codex-plugin/`, `.agents/`), the `earn` skill (`skills/earn/SKILL.md`), and a prebuilt MCP server
bundle. **There is no server source here.** What a tool does is built in
[TemporaLabs/treasury](https://github.com/TemporaLabs/treasury); change it there.

## Checks

All run in CI (`.github/workflows/validate.yml`); run them locally before a pull request.

```bash
bash scripts/lint-skill.sh           # spec-validates skills/earn with the official skill validator
bash scripts/check-bundle-source.sh  # copied files are byte-identical to the product at the pinned ref
bash scripts/check-versions.sh       # every declaration of this repository's version agrees
```

CI also starts `dist/mcp-server.mjs` and fails if the tool table in `SKILL.md` does not match the
server's real `tools/list`.

## Rules

- **Never edit the copied files by hand.** `dist/mcp-server.mjs`, `registry/vaults.json`, `NOTICE` and
  `THIRD_PARTY_NOTICES.md` are copies of the product's files at the ref named in `bundle-source.json`.
  A refresh copies them and moves that pin **in the same commit**. The ref must be a `vX.Y.Z` tag or a
  full 40-character commit SHA, never a branch name.
- **The server never signs or sends.** The bundle prepares unsigned calls only. Nothing added here may
  hold a key, sign, or send, including instructions in `SKILL.md`.
- **A change to the skill's `description:` is a behavioural change**, because it decides whether the
  skill is reached at all. Measure it by running the plugin: `claude -p --plugin-dir <this tree>` from
  a working directory that is not this tree, then check which tools the run actually invoked. Wording
  that reads better is not evidence.
- **Version numbers move together.** `package.json`'s version is what the bundled server reports as
  its own, so it and every manifest must agree; `check-versions.sh` enforces this. Maintainers bump
  versions at release, not in feature pull requests.

## Pull requests

- Target the current `release/vX.Y.Z` branch, not `main`.
- One change per pull request; a documentation fix found along the way gets its own.
- Security issues go through private vulnerability reporting ([`SECURITY.md`](SECURITY.md)), never a
  public issue.
