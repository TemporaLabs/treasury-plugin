#!/usr/bin/env bash
# The files this repository carries from the product must be byte-identical to the product's own
# copies at the ref `bundle-source.json` names. Without this, the bundle can fall arbitrarily far
# behind while every other gate stays green — the tool-table check compares tool NAMES, and a
# refresh that changes response fields changes no tool name (treasury-plugin#7).
#
# Runs standalone: `bash scripts/check-bundle-source.sh`. Needs network access to github.com and
# nothing else — no token, both repositories are public.
set -euo pipefail
cd "$(dirname "$0")/.."

PIN=bundle-source.json

# Hardcoded HERE rather than read from the pin, deliberately. A file list the pin could set is a
# list the pin could shorten, and a gate that silently checks fewer files is the failure this is
# supposed to prevent. Narrowing it has to be a visible edit to CI.
#
# LICENSE is absent on purpose and is not an oversight: validate.yml already pins it to the
# canonical Apache-2.0 text measured against apache.org. That is a STRONGER claim than agreeing
# with the product, which cross-repository identity could only weaken — two repositories can agree
# on the wrong licence.
FILES=(dist/mcp-server.mjs registry/vaults.json NOTICE THIRD_PARTY_NOTICES.md)

err() { echo "::error::$*"; FAIL=1; }
FAIL=0

[ -f "$PIN" ] || { echo "::error::$PIN is missing — nothing declares which product release this bundle came from"; exit 1; }

REPO=$(python3 -c 'import json,sys;print(json.load(open(sys.argv[1]))["repository"])' "$PIN")
REF=$(python3 -c 'import json,sys;print(json.load(open(sys.argv[1]))["ref"])' "$PIN")

# `owner/name`, nothing else — this string goes into a URL.
[[ "$REPO" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] || { echo "::error::$PIN: repository \"$REPO\" is not owner/name"; exit 1; }

# 🔴 THE REF MUST NOT BE ABLE TO MOVE. A branch name passes a naive fetch and then means something
# different tomorrow, so this gate would compare against whatever the product's default branch
# happens to hold and call any answer a pass. Only two shapes are accepted: a release tag, or a
# full 40-character commit SHA — the mid-cycle case, where the bundle is refreshed from a product
# commit that has not been tagged yet. A short SHA is refused because it is a prefix, not an
# identity.
#
# 🔴 FETCHING A COMMIT IS NOT EVIDENCE THAT IT IS STILL PART OF THE PRODUCT'S HISTORY, and this
# comment claimed the opposite until it was measured. GitHub serves any full SHA it still holds,
# reachable or not, so a commit orphaned by a history rewrite fetches fine and compares fine — the
# pin then names something no branch or tag can reach, which is the provenance failure this file
# exists to prevent, passing green. Measured on a real orphan: `d7357151…`, the product's pre-rewrite
# default-branch tip, fetched and compared clean. The earlier test used a NONEXISTENT SHA, which does
# fail — a different target, and the reason the false claim survived. So the commit path below checks
# REACHABILITY separately from retrieval.
if [[ "$REF" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  KIND=tag
elif [[ "$REF" =~ ^[0-9a-f]{40}$ ]]; then
  KIND=commit
else
  echo "::error::$PIN: ref \"$REF\" is neither a vX.Y.Z tag nor a full 40-character commit SHA."
  echo "::error::A branch name moves, so a comparison against it proves nothing tomorrow; a short SHA is a prefix, not an identity. Both are refused on purpose."
  exit 1
fi

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
URL="https://github.com/$REPO.git"

echo "comparing against $REPO at $KIND $REF"

# No pipe on the fetch: piping to head/tail would hand this `if` the exit status of the PIPE, and
# a failed clone would read as success. Everything below assumes the fetch either worked or we left.
if [ "$KIND" = tag ]; then
  if ! GIT_TERMINAL_PROMPT=0 git -c advice.detachedHead=false clone -q --depth 1 --branch "$REF" --no-tags "$URL" "$WORK/product"; then
    echo "::error::could not fetch $REPO at tag $REF — the tag does not exist, or the fetch failed."
    echo "::error::Failing rather than skipping: a gate that passes when it cannot read the other side compares nothing and always agrees."
    exit 1
  fi
else
  P="$WORK/product"
  git init -q "$P"
  git -C "$P" remote add origin "$URL"
  # `--filter=blob:none` fetches the whole commit graph without the file contents, which is what
  # makes an ancestry question answerable at all: `--depth 1` would give a history one commit deep,
  # where `merge-base --is-ancestor` cannot tell an orphan from a parent it simply has not been
  # handed. Blobs arrive on demand at checkout below. Measured at 0.5s and 284K on this product.
  if ! GIT_TERMINAL_PROMPT=0 git -C "$P" fetch -q --filter=blob:none origin \
      'refs/heads/main:refs/published/main' \
      'refs/heads/release/v*:refs/published/release/*' \
      'refs/tags/v*:refs/published/tags/*'; then
    echo "::error::could not read $REPO's published refs — failing rather than guessing at reachability."
    exit 1
  fi
  if ! GIT_TERMINAL_PROMPT=0 git -C "$P" fetch -q --filter=blob:none origin "$REF"; then
    echo "::error::could not fetch $REPO at commit $REF — no such commit."
    echo "::error::Failing rather than skipping: a gate that passes when it cannot read the other side compares nothing and always agrees."
    exit 1
  fi
  # Retrieval succeeded; now the separate question. Reachable from a published ref, or orphaned?
  REACHED=""
  for r in $(git -C "$P" for-each-ref --format='%(refname)' refs/published); do
    if git -C "$P" merge-base --is-ancestor "$REF" "$r" 2>/dev/null; then
      REACHED="$REACHED ${r#refs/published/}"
    fi
  done
  if [ -z "$REACHED" ]; then
    echo "::error::$REPO holds commit $REF but no published ref reaches it — it is orphaned, most likely by a history rewrite."
    echo "::error::It fetches and it would compare clean, which is exactly why this is checked separately: a commit nothing can reach is not provenance, it is an object the server has not collected yet."
    exit 1
  fi
  echo "  reachable from:$REACHED"
  git -C "$P" checkout -q "$REF"
fi

# The fetch succeeding does not mean the files are there. Assert presence separately, so a product
# tree that legitimately fetched but no longer carries one of these fails loudly instead of the
# comparison quietly having nothing to do.
for f in "${FILES[@]}"; do
  [ -f "$f" ]                 || err "$f is missing from THIS repository"
  [ -f "$WORK/product/$f" ]   || err "$f is missing from $REPO at $REF"
done
[ "$FAIL" = 0 ] || exit 1

for f in "${FILES[@]}"; do
  mine=$(sha256sum "$f" | cut -d' ' -f1)
  theirs=$(sha256sum "$WORK/product/$f" | cut -d' ' -f1)
  if [ "$mine" = "$theirs" ]; then
    printf '  ok      %-24s %s\n' "$f" "${mine:0:16}…"
  else
    printf '  STALE   %-24s here %s…  %s %s…\n' "$f" "${mine:0:16}" "$REF" "${theirs:0:16}"
    err "$f does not match $REPO at $REF — here ${mine:0:16}…, there ${theirs:0:16}…. Refresh it, or move the ref in $PIN to the release this tree actually carries."
  fi
done
[ "$FAIL" = 0 ] || exit 1

echo "all ${#FILES[@]} carried files are byte-identical to $REPO at $REF"

# ─── advisory, never blocking ────────────────────────────────────────────────────────────────────
# What the check above proves is that the bundle matches the release it CLAIMS. It cannot prove the
# claim is current — that limitation is named in treasury-plugin#7 itself. This closes the visible
# half of it: if the product has tagged something newer, say so. It does NOT fail, because the
# product's release cadence is not this repository's, and a red build on every unrelated pull
# request the moment the product ships would train everyone to ignore the colour.
LATEST=$(GIT_TERMINAL_PROMPT=0 git ls-remote --tags --refs "$URL" 'refs/tags/v[0-9]*' 2>/dev/null \
  | sed 's#.*refs/tags/##' | sort -V | tail -1 || true)
if [ -n "$LATEST" ] && [ "$KIND" = tag ] && [ "$LATEST" != "$REF" ]; then
  echo "::warning::$REPO has released $LATEST; this tree is pinned to $REF. Not a failure — but if $LATEST changed the bundle, refreshing is a release-time decision, not an oversight."
fi
