#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════
# ios/build_staging.sh — Build iOS STAGING flavor
# Usage:
#   ./scripts/ios/build_staging.sh verify     # build nhanh, no-codesign, chỉ check code OK
#   ./scripts/ios/build_staging.sh ipa        # build .ipa thật để upload TestFlight
# ═══════════════════════════════════════════════════════════

set -e

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

TARGET="${1:-ipa}"
FLAVOR="staging"

echo -e "${YELLOW}🟡 [iOS] Building ${FLAVOR} flavor — target: ${TARGET}${NC}"

run_gen() {
  echo "🔧 Running build_runner..."
  dart run build_runner build --delete-conflicting-outputs
}

build_verify() {
  echo "🍎 Building iOS ${FLAVOR} (no-codesign, verify only)..."

  flutter build ios \
    --flavor "${FLAVOR}" \
    --dart-define=FLAVOR="${FLAVOR}" \
    --no-codesign

  echo -e "${GREEN}✅ Verify build completed — KHÔNG dùng để cài máy thật hoặc upload TestFlight${NC}"
}

build_ipa() {
  echo "🍎 Building iOS ${FLAVOR} IPA (for TestFlight upload)..."

  # Clean để tránh dính cache/Pods cũ gây lỗi "FLAVOR is missing"
  flutter clean
  rm -rf ios/Pods ios/Podfile.lock ios/.symlinks
  rm -rf ~/Library/Developer/Xcode/DerivedData/Runner-*
  flutter pub get
  (cd ios && pod install --repo-update)

  flutter build ipa \
    --flavor "${FLAVOR}" \
    --dart-define=FLAVOR="${FLAVOR}" \
    --release

  IPA_FILE=$(find build/ios/ipa -maxdepth 1 -iname "*.ipa" | head -n 1)

  if [[ -z "$IPA_FILE" ]]; then
    echo -e "${RED}❌ Không tìm thấy file .ipa${NC}"
    exit 1
  fi

  echo ""
  echo "🔍 Verify nhanh file: $IPA_FILE"
  TMP_DIR=$(mktemp -d)
  unzip -q -o "$IPA_FILE" -d "$TMP_DIR"
  APP_PATH=$(find "$TMP_DIR/Payload" -maxdepth 1 -iname "*.app" | head -n 1)

  echo "  - CFBundleDevelopmentRegion: $(plutil -p "$APP_PATH/Info.plist" | grep CFBundleDevelopmentRegion || echo 'KHÔNG TÌM THẤY')"
  echo "  - Privacy manifest device_info_plus:"
  find "$TMP_DIR" -iname "PrivacyInfo.xcprivacy" | grep -i device_info || echo "    KHÔNG TÌM THẤY"
  rm -rf "$TMP_DIR"

  echo ""
  echo -e "${GREEN}✅ IPA built: ${IPA_FILE}${NC}"
  echo "   Upload qua Transporter hoặc: ./scripts/ios/upload_testflight.sh \"${IPA_FILE}\""
}

run_gen

case "$TARGET" in
  verify)
    build_verify
    ;;
  ipa)
    build_ipa
    ;;
  *)
    echo -e "${RED}❌ Unknown target: ${TARGET}${NC}"
    echo "Usage: ./scripts/ios/build_staging.sh [verify|ipa]"
    exit 1
    ;;
esac

echo -e "${GREEN}🎉 [iOS] ${FLAVOR} build completed successfully${NC}"