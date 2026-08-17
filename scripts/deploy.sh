#!/usr/bin/env bash
# Deploy night-moves (nightmoves.racesplit.org) to Fly.io.
# Usage: ./scripts/deploy.sh   (or: make deploy)
set -euo pipefail

APP="night-moves"
BRANCH="night-moves"

# Safety: only deploy from the night-moves branch
current_branch="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$current_branch" != "$BRANCH" ]]; then
  echo "✋ Refusing to deploy: you're on '$current_branch', not '$BRANCH'."
  echo "   Switch with: git checkout $BRANCH"
  exit 1
fi

# Safety: refuse to deploy uncommitted changes
if ! git diff-index --quiet HEAD --; then
  echo "✋ Refusing to deploy: uncommitted changes in the working tree."
  echo "   Commit or stash them first."
  exit 1
fi

# Keep origin in sync with what we're deploying
git fetch -q "origin" "$BRANCH"
if [[ "$(git rev-parse HEAD)" != "$(git rev-parse "origin/$BRANCH")" ]]; then
  echo "⚠️  HEAD is not pushed — pushing to origin/$BRANCH first."
  git push origin "$BRANCH"
fi

echo "🚀 Deploying $APP to Fly.io (remote build)…"
exec flyctl deploy --remote-only
