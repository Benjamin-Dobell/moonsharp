#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SRC_DIR="$REPO_ROOT/src/MoonSharp.Interpreter"
OUT_DIR="$REPO_ROOT/.upm-staging/org.moonsharp.moonsharp"
VERSION="${1:-2.0.0-local}"

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR/Runtime"

rsync -a \
  --exclude 'bin/' \
  --exclude 'obj/' \
  --exclude '_Projects/' \
  --exclude '*.csproj' \
  --exclude '*.sln' \
  --exclude '*.snk' \
  "$SRC_DIR/" \
  "$OUT_DIR/Runtime/"

cat > "$OUT_DIR/package.json" <<JSON
{
  "name": "org.moonsharp.moonsharp",
  "version": "$VERSION",
  "displayName": "MoonSharp",
  "description": "A Lua interpreter for Unity and .NET.",
  "unity": "2020.3",
  "author": {
    "name": "MoonSharp Contributors"
  },
  "license": "MIT"
}
JSON

cat > "$OUT_DIR/Runtime/MoonSharp.Interpreter.asmdef" <<'JSON'
{
  "name": "MoonSharp.Interpreter",
  "rootNamespace": "MoonSharp.Interpreter",
  "references": [],
  "includePlatforms": [],
  "excludePlatforms": [],
  "allowUnsafeCode": false,
  "overrideReferences": false,
  "precompiledReferences": [],
  "autoReferenced": true,
  "defineConstraints": [],
  "versionDefines": [],
  "noEngineReferences": false
}
JSON

cp "$REPO_ROOT/LICENSE" "$OUT_DIR/LICENSE"

cat > "$OUT_DIR/README.md" <<README
# MoonSharp Unity Package (Local Staging)

This directory is generated from source by:

\`tools/upm/stage-local-package.sh\`

Install options:

1. Local path in Unity \`manifest.json\`:
   \`\"org.moonsharp.moonsharp\": \"file:$OUT_DIR\"\`
2. Tarball via Unity Package Manager:
   Use "Add package from tarball..." and select a release \`.tgz\` asset.
README

echo "Staged: $OUT_DIR"
