# Changelog

All notable changes to the Agent Treasury plugin are recorded here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versions follow [SemVer](https://semver.org/).

## [0.1.0] - 2026-09-18

Carries `@temporalabs/treasury` 0.1.0.

### Added
- Plugin manifests for Claude Code, Codex and the `.agents` marketplace format.
- The `earn` skill (`skills/earn/SKILL.md`).
- The committed MCP server bundle (`dist/mcp-server.mjs`) and the vault registry it reads
  (`registry/vaults.json`), matching `@temporalabs/treasury` 0.1.0 byte for byte.
- The server contacts the RPC you configure and nothing else: no analytics, no yield API, no vendor.
  It quotes no rate, and a position's accrued yield is read from the vault's own on-chain events.

### Changed
- Refreshed the bundle and registry to `TemporaLabs/treasury@99b7b65f9e2fbe3f6bfec6fd3aa25e333f7afe0c`
  after its vault-identity rework (treasury#7, treasury#8): a vault is now named by its own on-chain
  ERC-20 `symbol` rather than an internal registry `slug`, `earn_vaults` reports `name` in place of
  `displayName`, and every response that commits money (`earn_prepare_deposit`, `earn_status`'s
  pre-flight, `earn_quote`'s deposit branch) now carries the vault's `warning` disclosure — not only
  the discovery call. This landed before this repository's own first release to `main`, so the
  plugin's initial public artifact carries the fixed shape rather than the internal-slug/no-warning
  shape it would otherwise have shipped with.
- Refreshed the bundle again to `TemporaLabs/treasury@4d4b0de7962b0257680b2d9f570a7bfa20feae75`,
  picking up treasury#14 and treasury#15: `earn_balance` now returns `scan.depositTxs` /
  `scan.withdrawTxs` (the transactions behind the basis scan, so an operator gets an explorer link
  without anyone rebuilding the log query), and every `earn_prepare_*` call carries `function` and
  `args` — the decoded signature and named arguments a block explorer's Write Contract form asks
  for. `skills/earn/SKILL.md` is updated to match: the signer hand-off no longer teaches
  hand-decoding calldata, because the tool now supplies the decoded form directly.

  Both entries above name a COMMIT rather than a branch deliberately. `release/v0.1.0` moves, so a
  provenance claim pinned to it stops being checkable the moment it does — the first entry
  originally named the branch and had already become unverifiable by the time the second was
  written.

### Note

`@temporalabs/treasury` is not yet published to npm. `.mcp.json` runs the bundle committed in this
repository directly (`node ${CLAUDE_PLUGIN_ROOT}/dist/mcp-server.mjs`) rather than resolving the
package by name. Once the package is published, this arrangement is replaced by an `npx` pin to
the exact published version — that is the ordering the plugin/product split was designed around,
not a change of plan.
