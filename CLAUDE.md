# CLAUDE.md — Tiếp Sóng

Đọc trước mỗi phiên. Chi tiết đầy đủ: `docs/DECISIONS.md` (lý do các quyết
định) và `.claude/skills/` (quy ước code, chỉ load khi liên quan).

## Dự án
Ứng dụng SOS/cứu trợ thiên tai, **hoạt động không cần internet** (Bluetooth
mesh relay giữa các điện thoại → sync server khi có mạng trở lại). Không
cạnh tranh Zalo SOS lúc có mạng — chỉ bổ sung lúc mất sóng hoàn toàn.

## Stack
| Layer | Chọn |
|---|---|
| Mobile | Flutter — BLoC, go_router, get_it+injectable, Dio, Hive |
| Offline | `bridgefy_flutter` (Bluetooth mesh) |
| Backend | Spring Boot — MVC (module đơn giản) / DDD (matching, priority) |
| DB | PostgreSQL + PostGIS |
| Host | VPS ngoài Việt Nam / multi-region |

Package Flutter: `tiep_song`. Package Java: `com.tiepsong`.

## Quy tắc cứng — không suy diễn, không bỏ qua
1. Ghi Hive local TRƯỚC khi broadcast mesh / gọi API. Lỗi bước sau không
   được xoá dữ liệu bước trước.
2. Sync server idempotent theo UUID client — retry là bình thường.
3. Không phụ thuộc SDK/nền tảng bên thứ 3 về công nghệ; dữ liệu sync phải
   xuất được cho chính quyền/Hội Chữ thập đỏ dùng.
4. Luôn dùng lại `common/widgets` (`AppButton`, `AppScaffold`...) và
   `AppColor`/`AppTextStyle` — không viết widget Material thô trong feature.
5. UI hành động khẩn cấp: tối giản, tương phản cao, ít bước — không áp
   chuẩn UX nhiều-bước-xác-nhận thông thường.
6. Quyết định kiến trúc mới quan trọng → thêm mục vào `docs/DECISIONS.md`.

## Trước khi code
- Dart trong `lib/` → đọc `.claude/skills/flutter-architecture/SKILL.md`.
- Java backend → đọc `.claude/skills/spring-boot-backend/SKILL.md`.
- Mesh/Bluetooth chỉ test được trên ≥2 thiết bị thật, không phải emulator.
- Thứ tự MVP: SOS local→mesh→sync→server chạy được trước, polish sau.

## Cấu trúc repo
```
tiep_song/            lib/common, lib/features   (Flutter)
tiepsong-backend/     src/main/java/com/tiepsong   (Spring Boot)
docs/DECISIONS.md   log quyết định kiến trúc
.claude/skills/     quy ước code chi tiết
```
