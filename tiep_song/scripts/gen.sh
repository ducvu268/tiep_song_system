#!/usr/bin/env bash

set -e

echo "🔧 Running code generation..."
dart run build_runner build \
  --delete-conflicting-outputs

echo "✅ Code generation completed"