#!/usr/bin/env bash
# Local self-check for the bundle: patch/dependency consistency, submodule checkouts,
# and syntax of the bundle entry. Run from the repo root.
set -euo pipefail
cd "$(dirname "$0")/.."

python3 - <<'PY'
import json, os, sys
import yaml

bundle = 'bundle'
pkg = json.load(open(os.path.join(bundle, 'package.json')))
deps = pkg.get('dependencies') or {}
rows = yaml.safe_load(open(os.path.join(bundle, 'cordis.patch.yml')))[0]['insert']
names = [r['name'] for r in rows]

missing_dep = [n for n in names if n not in deps]
missing_row = [n for n in deps if n not in names]
print(f'rows={len(rows)} deps={len(deps)}')
if missing_dep:
    print('rows without dependency:', missing_dep); sys.exit(1)
if missing_row:
    print('dependencies without row:', missing_row); sys.exit(1)

skip_plugins = os.environ.get('SKIP_PLUGIN_CHECK') == '1'
for name, spec in deps.items():
    if spec.startswith('file:') and not skip_plugins:
        path = os.path.normpath(os.path.join(bundle, spec[len('file:'):]))
        if not os.path.exists(os.path.join(path, 'package.json')):
            print('missing plugin checkout:', name, path); sys.exit(1)
print('patch/deps consistent')
PY

node --check bundle/index.js
echo 'bundle index.js syntax ok'
git submodule status >/dev/null || true
echo 'submodules:'
git submodule status | sed 's/^/  /'
