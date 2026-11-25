#!/usr/bin/env bash
# Update the collection: pull the umbrella repo, fast-forward submodules to the
# commits recorded here, regenerate the merged patch, and run the self-check.
set -euo pipefail
cd "$(dirname "$0")/.."

git pull --ff-only
git submodule update --init --recursive
python3 scripts/build-bundle-patch.py
bash scripts/check.sh
echo
echo "updated. In DSH: remove the old 'dsh-plugins-hypo' bundle, then re-add ./bundle"
