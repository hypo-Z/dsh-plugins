#!/usr/bin/env bash
# Build a self-contained installable tarball from bundle/ + plugins/.
#
# The staged package vendors every plugin directory inside ./plugins and rewrites
# the file: dependencies to point at them, so the .tgz can be installed without a
# git clone or submodules:
#
#   dsh plugin --profile desktop add ./dist/dsh-plugins-hypo-0.1.0.tgz
#
# Run from the repo root. Submodules must be initialized first.
set -euo pipefail
cd "$(dirname "$0")/.."

status=$(git submodule status || true)
if [ -z "$status" ]; then
  echo "no submodules found; run ./scripts/init-submodules.sh first" >&2
  exit 1
fi

missing=$(printf '%s\n' "$status" | awk '$1 ~ /^-/ {print $2}')
if [ -n "$missing" ]; then
  echo "uninitialized submodules:" >&2
  echo "$missing" >&2
  echo "run ./scripts/init-submodules.sh" >&2
  exit 1
fi

rm -rf build dist
mkdir -p build/bundle dist
cp -R bundle/. build/bundle/
rm -rf build/bundle/node_modules build/bundle/pnpm-lock.yaml

python3 - <<'PY'
import json
import os
import shutil

root = os.getcwd()
stage = os.path.join(root, 'build/bundle')
plugins = os.path.join(root, 'plugins')

pkg_path = os.path.join(stage, 'package.json')
pkg = json.load(open(pkg_path))
deps = pkg['dependencies']

# dependency name -> source dir under plugins/
source = {
    'dsh-lamplit': 'dsh-lamplit',
    'dsh-pet': 'dsh-pet',
    'dsh-stock-bar': 'dsh-stock-bar',
    'dsh-portfolio': 'dsh-portfolio',
    'dsh-music-panel': 'dsh-music-panel',
    'dsh-bilibili-multiview': 'dsh-bilibili-multiview',
    '@dsh-external/dsh-bili-widget': 'dsh-bili-widget',
    'dsh-dream-skin': 'dsh-dream-skin',
    'dsh-nav-grid': 'dsh-nav-grid',
    'dsh-fork-sync': 'dsh-fork-sync',
}

target_plugins = os.path.join(stage, 'plugins')
os.makedirs(target_plugins, exist_ok=True)
for name, directory in source.items():
    src = os.path.join(plugins, directory)
    if not os.path.exists(os.path.join(src, 'package.json')):
        raise SystemExit(f'missing plugin checkout: {src}')
    dst = os.path.join(target_plugins, directory)
    shutil.copytree(
        src,
        dst,
        ignore=shutil.ignore_patterns('.git', 'node_modules', '.DS_Store', '*.log'),
    )
    deps[name] = 'file:./plugins/' + directory

files = pkg.get('files') or []
if 'plugins' not in files:
    files.append('plugins')
pkg['files'] = files
json.dump(pkg, open(pkg_path, 'w'), ensure_ascii=False, indent=2)
print('vendored plugins:', len(source))
PY

cd build/bundle
npm pack --ignore-scripts --silent >/dev/null
packed=$(ls -1 *.tgz | head -1)
mv "$packed" "$OLDPWD/dist/$packed"
cd "$OLDPWD"

size=$(du -h "dist/$packed" | cut -f1)
echo "built dist/$packed ($size)"
echo
echo "install with:"
echo "  dsh plugin --profile desktop add $PWD/dist/$packed"
