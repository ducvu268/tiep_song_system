#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════
# android/build_production.sh — Build Android PRODUCTION flavor
# Usage:
#   ./scripts/android/build_production.sh apk
#   ./scripts/android/build_production.sh aab
#   ./scripts/android/build_production.sh both
#
# Lưu ý: AAB là format khuyến nghị để upload Google Play.
# APK chỉ dùng khi cần cài trực tiếp / phân phối ngoài Play Store.
# ═══════════════════════════════════════════════════════════

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

TARGET="${1:-aab}"
FLAVOR="production"

echo -e "${YELLOW}🟡 [Android] Building ${FLAVOR} flavor — target: ${TARGET}${NC}"

read -p "⚠️  Bạn đang build bản PRODUCTION. Xác nhận tiếp tục? (y/N) " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo -e "${RED}❌ Đã hủy build production.${NC}"
  exit 1
fi

run_gen() {
  echo "🔧 Running build_runner..."
  dart run build_runner build --delete-conflicting-outputs
}

build_apk() {
  echo "📦 Building Android ${FLAVOR} APK..."

  flutter build apk \
    --flavor "${FLAVOR}" \
    --dart-define=FLAVOR="${FLAVOR}" \
    --release

  APK_PATH=$(find build/app/outputs/flutter-apk -iname "*${FLAVOR}*.apk" | head -n 1)
  echo -e "${GREEN}✅ APK build completed: ${APK_PATH}${NC}"
}

build_aab() {
  echo "📦 Building Android ${FLAVOR} AAB..."

  flutter build appbundle \
    --flavor "${FLAVOR}" \
    --dart-define=FLAVOR="${FLAVOR}" \
    --release

  AAB_PATH=$(find build/app/outputs/bundle -iname "*${FLAVOR}*.aab" | head -n 1)
  echo -e "${GREEN}✅ AAB build completed: ${AAB_PATH}${NC}"
  echo "   Upload lên Google Play Console > Production/Internal testing."
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
    echo "Usage: ./scripts/android/build_production.sh [apk|aab|both]"
    exit 1
    ;;
esac

echo -e "${GREEN}🎉 [Android] ${FLAVOR} build completed successfully${NC}"