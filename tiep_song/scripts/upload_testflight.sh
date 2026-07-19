#!/bin/bash
set -euo pipefail

# ============================================================
# upload_testflight.sh
# Upload file .ipa lên App Store Connect / TestFlight
# bằng Transporter CLI (xcrun altool) — thay thế thao tác kéo-thả
# trong app Transporter.
#
# Cách dùng:
#   ./scripts/ios/upload_testflight.sh build/ios/ipa/ten_app.ipa
#
# YÊU CẦU TRƯỚC KHI CHẠY:
# 1. Tạo App Store Connect API Key tại:
#    https://appstoreconnect.apple.com/access/api
#    (Users and Access > Integrations > App Store Connect API)
# 2. Tải file .p8 về, đặt vào:
#    ~/.appstoreconnect/private_keys/AuthKey_<KEY_ID>.p8
# 3. Set 2 biến môi trường bên dưới (KEY_ID, ISSUER_ID)
#    lấy từ trang API Key ở bước 1.
# ============================================================

IPA_FILE="${1:-}"

if [[ -z "$IPA_FILE" || ! -f "$IPA_FILE" ]]; then
  echo "❌ Thiếu file .ipa hoặc file không tồn tại."
  echo "   Cách dùng: ./scripts/ios/upload_testflight.sh <đường-dẫn-file.ipa>"
  exit 1
fi

# ---- CHỈNH 2 GIÁ TRỊ NÀY (lấy từ App Store Connect > API Keys) ----
API_KEY_ID="${ASC_KEY_ID:-YOUR_KEY_ID}"
API_ISSUER_ID="${ASC_ISSUER_ID:-YOUR_ISSUER_ID}"
# --------------------------------------------------------------------

if [[ "$API_KEY_ID" == "YOUR_KEY_ID" || "$API_ISSUER_ID" == "YOUR_ISSUER_ID" ]]; then
  echo "❌ Chưa cấu hình API_KEY_ID / API_ISSUER_ID."
  echo "   Set qua biến môi trường trước khi chạy, ví dụ:"
  echo "     export ASC_KEY_ID=ABCD1234"
  echo "     export ASC_ISSUER_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  echo "   Hoặc sửa trực tiếp trong file script này."
  exit 1
fi

echo "📤 Đang upload $IPA_FILE lên TestFlight..."
echo "   (dùng App Store Connect API Key: $API_KEY_ID)"
echo ""

xcrun altool --upload-app \
  --type ios \
  --file "$IPA_FILE" \
  --apiKey "$API_KEY_ID" \
  --apiIssuer "$API_ISSUER_ID"

echo ""
echo "✅ Upload xong. Vào App Store Connect > TestFlight để theo dõi trạng thái xử lý"
echo "   (thường mất 5-30 phút, kiểm tra email nếu bị Invalid Binary)."