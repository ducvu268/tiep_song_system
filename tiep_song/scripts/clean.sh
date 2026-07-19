#!/usr/bin/env bash

set -e

echo "🧹 Cleaning project..."
flutter clean

dart run build_runner clean || true
flutter pub get

dart run build_runner build \
  --delete-conflicting-outputs

echo "✅ Clean completed"