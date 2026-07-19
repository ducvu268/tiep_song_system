#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════
# android/build_staging.sh — Build Android STAGING flavor
# Usage:
#   ./scripts/android/build_staging.sh apk
#   ./scripts/android/build_staging.sh aab
#   ./scripts/android/build_staging.sh both
# ═══════════════════════════════════════════════════════════

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

TARGET="${1:-apk}"
FLAVOR="staging"

echo -e "${YELLOW}🟡 [Android] Building ${FLAVOR} flavor — target: ${TARGET}${NC}"

run_gen() {
  echo "🔧 Running build_runner..."
  dart run build_runner build --delete-conflicting-outputs
}

build_apk() {
  echo "📦 Building Android ${FLAVOR} APK..."

  flutter build apk \
    --flavor "${FLAVOR}" \
    --dart-define=FLAVOR="${FLAVOR}"

  APK_PATH=$(find build/app/outputs/flutter-apk -iname "*${FLAVOR}*.apk" | head -n 1)
  echo -e "${GREEN}✅ APK build completed: ${APK_PATH}${NC}"
}

build_aab() {
  echo "📦 Building Android ${FLAVOR} AAB..."

  flutter build appbundle \
    --flavor "${FLAVOR}" \
    --dart-define=FLAVOR="${FLAVOR}"

  AAB_PATH=$(find build/app/outputs/bundle -iname "*${FLAVOR}*.aab" | head -n 1)
  echo -e "${GREEN}✅ AAB build completed: ${AAB_PATH}${NC}"
}

run_gen

case "$TARGET" in
  apk)
    build_apk
    ;;
  aab)
    build_aab
    ;;
  both)
    build_apk
    build_aab
    ;;
  *)
    echo -e "${RED}❌ Unknown target: ${TARGET}${NC}"
    echo "Usage: ./scripts/android/build_staging.sh [apk|aab|both]"
    exit 1
    ;;
esac

echo -e "${GREEN}🎉 [Android] ${FLAVOR} build completed successfully${NC}"