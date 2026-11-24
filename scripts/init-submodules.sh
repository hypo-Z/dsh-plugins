#!/usr/bin/env bash
# Initialize submodules with retries. GitHub flakiness on large repos (pet, music)
# often needs a second or third attempt; --depth 1 is deliberately NOT used so the
# recorded commit is checked out exactly (stock-bar's dev-1.11 is not its default branch).
set -uo pipefail
cd "$(dirname "$0")/.."

for attempt in 1 2 3; do
  echo "== submodule update (attempt $attempt)"
  if git submodule update --init --recursive; then
    git submodule status
    exit 0
  fi
  sleep 5
done

echo "some submodules failed; retry one by one:"
git submodule status | sed 's/^/  /'
echo "  git submodule update --init plugins/<name>"
exit 1
