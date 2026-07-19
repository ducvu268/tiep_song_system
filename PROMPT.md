# Prompt khởi động — paste nguyên văn vào Claude Code khi đứng ở thư mục rỗng

---

Tôi muốn bắt đầu 1 dự án mới từ đầu: **Tiếp Sóng** — ứng dụng cứu trợ
thiên tai offline-first cho Việt Nam.

Bối cảnh, stack, quy tắc cứng đã có sẵn trong `CLAUDE.md` (đọc file đó
trước — nó tự load mỗi phiên nên tôi không nhắc lại ở đây).

**Đây KHÔNG phải bài tập demo.** Thiết kế mọi quyết định như thể tính mạng
người dùng thật sự phụ thuộc vào việc dữ liệu không bị mất.

## Việc cần bạn làm ngay bây giờ

1. Đọc toàn bộ file trong `docs/DECISIONS.md` và `.claude/skills/` (đã có
   sẵn trong thư mục này) — đó là các quyết định kiến trúc tôi đã chốt qua
   nhiều buổi bàn bạc, KHÔNG phải gợi ý, hãy tuân theo.
2. Thư mục `tiep_song/` **đã có sẵn khung Flutter** (feature `sos` đầy đủ
   domain/data/presentation + design system `common/widgets`) — dùng nó
   làm điểm xuất phát, **đừng chạy `flutter create` đè lên**. Chạy
   `flutter pub get` rồi `dart run build_runner build
   --delete-conflicting-outputs` để sinh file `.g.dart` còn thiếu, sau đó
   `flutter analyze` để tìm lỗi compile (scaffold này viết tay, chưa build
   thử — có thể còn lỗi nhỏ, bạn cần rà và sửa trước khi code tiếp).
3. Khởi tạo `tiepsong-backend/` — Spring Boot app (Java, group
   `com.tiepsong`, dùng start.spring.io hoặc Spring CLI với dependencies:
   Web, JPA, PostgreSQL driver, Validation) — project này CHƯA có sẵn,
   tạo mới hoàn toàn theo
   `.claude/skills/spring-boot-backend/SKILL.md`.
4. Migration PostgreSQL + PostGIS cho bảng `sos_requests`, endpoint
   `POST /api/v1/sos` idempotent theo UUID.
5. Sau khi cả 2 phần chạy được (Flutter build không lỗi, Spring Boot start
   không lỗi, migration chạy được), dừng lại và báo cáo cho tôi trước khi
   làm tiếp — đừng tự ý build hết mọi tính năng trong 1 lần.

## Phạm vi MVP (làm đúng thứ tự, đừng nhảy cóc)

1. **Flutter — verify + hoàn thiện màn hình SOS end-to-end** (khung đã có
   sẵn trong `tiep_song/`, kiểm tra và sửa nếu lỗi): bấm SOS → lấy GPS →
   lưu Hive → broadcast qua Bridgefy mesh → hiện trạng thái cho user biết
   (đã lưu / đang relay / đã đồng bộ).
2. **Backend — nhận & lưu SOS:** endpoint nhận request, lưu PostgreSQL với
   PostGIS point, trả về xác nhận.
3. **Flutter — sync tự động:** khi có mạng trở lại (connectivity listener),
   tự đẩy toàn bộ SOS đang pending lên backend.
4. **Backend — truy vấn theo khu vực:** endpoint `GET /api/v1/sos/nearby`
   dùng `ST_DWithin`, trả danh sách SOS trong bán kính X km quanh 1 điểm —
   phục vụ cho đội cứu hộ/chính quyền tra cứu.
5. Sau khi 4 bước trên chạy được thật (test trên ≥2 thiết bị thật cho phần
   mesh), quay lại bàn tiếp: bản đồ hiển thị, tài khoản tình nguyện viên,
   matching đội cứu hộ.

## Ràng buộc chất lượng

- Code Flutter phải tuân thủ 100% convention trong SKILL.md — không tự
  sáng tạo cấu trúc khác, kể cả khi bạn nghĩ có cách "tốt hơn". Nếu thấy
  convention có vấn đề, nói ra để tôi quyết định, đừng tự ý đổi.
- Mọi thứ liên quan tới việc ghi dữ liệu SOS phải test được ngay cả khi
  không có mạng/Bluetooth (ví dụ: tắt wifi + tắt Bluetooth trên máy ảo, bấm
  SOS, kiểm tra dữ liệu vẫn nằm trong Hive).
- Viết `.env.example` cho cả 2 project, không hardcode secret.
- Sau mỗi milestone hoàn thành, cập nhật `docs/DECISIONS.md` nếu có quyết
  định kiến trúc mới phát sinh trong lúc code (ví dụ: đổi thư viện, đổi
  cấu trúc bảng).

## Việc tôi sẽ tự làm, bạn không cần lo

- Đăng ký Bridgefy API key thật (bridgefy.me) — tôi sẽ điền vào `.env`.
- Thuê VPS, chọn region.
- Liên hệ chính quyền địa phương/Hội Chữ thập đỏ về quy trình nhận dữ liệu.

Bắt đầu từ bước 1 ở trên. Hỏi tôi nếu có quyết định nào chưa rõ trong
`docs/DECISIONS.md` trước khi code.
