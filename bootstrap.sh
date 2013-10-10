#!/usr/bin/env sh

set -e

APP_ROOT="$(cd -P -- $(dirname -- "$0") && pwd)"
cd "$APP_ROOT"

echo "Setting up your environment..."

if command -v ruby >/dev/null; then
  echo "  + Ruby found: $(ruby --version)"
else
  echo "  x You need to install Ruby."
  exit 1
fi

if command -v bundle >/dev/null; then
  echo "  + Bundler found: $(bundle --version)"
else
  echo "  x You need to install Bundler:"
  echo "    gem install bundler"
  exit 1
fi

echo "  + Bootstrapping your gems..."
bundle install --standalone --binstubs --path vendor/gems $BUNDLER_OPTS

echo "Completed! You can now run bundle exec rake or bundle exec kitchen test"
