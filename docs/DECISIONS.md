# Quyết định kiến trúc — Tiếp Sóng

Ghi lại NGẮN GỌN các quyết định đã chốt và lý do, để không phải giải thích
lại từ đầu mỗi phiên vibe-coding mới. Claude Code nên đọc file này trước khi
đề xuất thay đổi kiến trúc.

## 1. Độc lập công nghệ khỏi Zalo, nhưng liên kết quy trình

Không dùng API/nền tảng Zalo. Tự xây toàn bộ stack. Nhưng dữ liệu SOS khi
đồng bộ lên server phải xuất được ra dạng chính quyền địa phương / Hội Chữ
thập đỏ dùng được (toạ độ, mức khẩn cấp, số người) — kể cả nếu họ chỉ nhận
qua điện thoại/email, không có tích hợp API. Không tự xây lực lượng cứu hộ
riêng.

## 2. Offline mesh: dùng Bridgefy SDK, không tự build BLE mesh stack

Lý do: tự build giao thức Bluetooth mesh (provisioning, relay, TTL,
mã hoá) là khối lượng công việc rất lớn, không hợp cho MVP 1 mobile dev.
Bridgefy đã kiểm chứng qua thảm hoạ/biểu tình thật, có Flutter plugin chính
thức (`bridgefy_flutter`). Cân nhắc tự build lại (dùng BLE Mesh API native
của Android 14+ / CoreBluetooth) CHỈ khi đã validate được nhu cầu và cần
thoát phụ thuộc SDK bên thứ 3.

## 3. Chiến lược dữ liệu: local-first, mesh-always, server-when-possible

Đảo ngược hoàn toàn so với pattern "network-first + cache fallback" thường
thấy trong app thương mại — vì network hiếm khi có sẵn trong bối cảnh app
này hoạt động.

Thứ tự bắt buộc mỗi khi tạo 1 SOS request:
1. Ghi Hive (local) trước — KHÔNG BAO GIỜ được phép thất bại thầm lặng.
2. Broadcast qua mesh — cố gắng, nhưng lỗi ở bước này KHÔNG được làm mất
   dữ liệu đã lưu ở bước 1.
3. Sync server — chạy riêng, trigger bởi connectivity listener, không chặn
   luồng chính.

## 4. PostgreSQL + PostGIS, không dùng lat/long thường

Bài toán cốt lõi ở backend là truy vấn không gian ("tìm SOS gần điểm X
trong bán kính Y km", "gom cụm SOS theo khu vực"). PostGIS xử lý việc này
hiệu quả và chính xác hơn nhiều so với tính khoảng cách Haversine thủ công.
Bật extension PostGIS ngay từ migration đầu tiên.

## 5. VPS đặt ngoài Việt Nam (hoặc multi-region)

Nếu thiên tai làm hạ tầng internet nội địa bị ảnh hưởng diện rộng, backend
đặt trong nước có thể sập đúng lúc cần nhất. Ưu tiên VPS tại Singapore/HK
hoặc provider có multi-region, để backend luôn "sống" độc lập với tình
trạng hạ tầng trong nước.

## 6. Kiến trúc mobile: Clean Architecture theo feature (đã có sẵn convention)

Tham khảo từ project `nbc-refmi-fabric-mobile-app` hiện có của founder. Bắt
buộc mọi feature mới tuân theo cấu trúc `data / domain / presentation`,
BLoC + `get_it`/`injectable`, và tái sử dụng design system trong
`common/widgets` thay vì viết widget Material thô. Chi tiết đầy đủ ở
`.claude/skills/flutter-architecture/SKILL.md`.

## 7. Kiến trúc backend: MVC cho module đơn giản, DDD cho lõi nghiệp vụ

Không ép toàn bộ backend theo 1 kiểu. Module CRUD đơn giản (quản lý tài
khoản, danh mục loại nhu cầu cứu trợ...) dùng MVC 3 lớp thông thường
(Controller/Service/Repository) cho nhanh. Module lõi có nghiệp vụ phức
tạp thật sự (matching SOS request với đội cứu hộ gần nhất, tính ưu tiên xử
lý) dùng DDD (aggregate, domain service, tách khỏi persistence). Chi tiết
ở `.claude/skills/spring-boot-backend/SKILL.md`.

## 8. Tên dự án: `tiep_song`

Package Flutter: `tiep_song`. Package Java gốc dự kiến: `com.tiepsong.*` (xác
nhận lại với founder trước khi generate Spring Boot project trên
start.spring.io).
