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
- Refreshed the bundle and registry to the product repository's `release/v0.1.0` tip after its
  vault-identity rework (treasury#7, treasury#8): a vault is now named by its own on-chain ERC-20
  `symbol` rather than an internal registry `slug`, `earn_vaults` reports `name` in place of
  `displayName`, and every response that commits money (`earn_prepare_deposit`, `earn_status`'s
  pre-flight, `earn_quote`'s deposit branch) now carries the vault's `warning` disclosure — not only
  the discovery call. This landed before this repository's own first release to `main`, so the
  plugin's initial public artifact carries the fixed shape rather than the internal-slug/no-warning
  shape it would otherwise have shipped with.

### Note

`@temporalabs/treasury` is not yet published to npm. `.mcp.json` runs the bundle committed in this
repository directly (`node ${CLAUDE_PLUGIN_ROOT}/dist/mcp-server.mjs`) rather than resolving the
package by name. Once the package is published, this arrangement is replaced by an `npx` pin to
the exact published version — that is the ordering the plugin/product split was designed around,
not a change of plan.
