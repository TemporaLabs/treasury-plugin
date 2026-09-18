# Security Policy

## Scope

This repository is the Agent Treasury plugin — the packaging a host installs: the plugin
manifests, the `earn` skill, and the committed MCP server bundle they point at. A report about
any of those belongs here: a manifest or `.mcp.json` that misdirects the plugin's own install or
launch, and the skill text itself.

A defect in what the server actually does when it runs — a prepared call, a balance figure, a
pre-flight verdict — belongs to the server's own repository:
[TemporaLabs/treasury](https://github.com/TemporaLabs/treasury). Report it there.

## Reporting a vulnerability

**Please do not open a public issue for a security problem.**

Use GitHub's private vulnerability reporting for this repository: **Security → Report a
vulnerability**, or open an advisory directly at
[Security advisories](https://github.com/TemporaLabs/treasury-plugin/security/advisories/new).
It is private between you and the maintainers until a fix ships.

## Supported versions

Security fixes go to the latest release. Pre-1.0 releases are not patched retroactively; upgrade.
