---
name: spring-boot-backend
description: Dùng skill này khi viết, sửa, hoặc review code Java Spring Boot trong dự án Tiếp Sóng — tạo entity, endpoint REST API, migration PostgreSQL, hoặc quyết định tổ chức 1 module theo MVC hay DDD.
---

# Spring Boot Backend — Tiếp Sóng

Backend chỉ đóng vai trò **đồng bộ + điều phối** khi thiết bị có mạng trở
lại — không phải nguồn sự thật duy nhất (client Flutter mới là nơi giữ dữ
liệu an toàn khi offline, xem `docs/DECISIONS.md` mục 3). Điều này ảnh
hưởng trực tiếp đến thiết kế API: mọi endpoint ghi dữ liệu phải **idempotent**
theo `id` (UUID sinh từ client) — retry khi mạng chập chờn không được tạo
bản ghi trùng.

## MVC hay DDD? — quyết định theo độ phức tạp nghiệp vụ, không theo thói quen

**Dùng MVC 3 lớp (Controller → Service → Repository, JPA entity = domain
luôn)** cho module CRUD đơn giản, ít business rule:
- Quản lý tài khoản/tình nguyện viên
- Danh mục loại nhu cầu cứu trợ (`ReliefNeedType`)
- Lịch sử thao tác, log

**Dùng DDD (Aggregate root, Domain Service tách khỏi Entity persistence,
Repository interface ở domain layer + implementation riêng ở
infrastructure)** CHỈ cho module có nghiệp vụ thật sự phức tạp:
- Matching SOS request với đội cứu hộ gần nhất (nhiều rule: khoảng cách,
  mức độ khẩn cấp, năng lực đội cứu hộ hiện có)
- Tính toán độ ưu tiên xử lý khi có nhiều SOS request cùng lúc trong 1 khu
  vực (số người, loại nhu cầu, thời gian chờ)

Không ép cả 2 module đầu tiên (SOS ingest, health-check) vào DDD — chúng
đơn giản, MVC là đủ và nhanh hơn để có MVP chạy được.

## PostGIS — bắt buộc từ migration đầu tiên

```sql
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE sos_requests (
    id              UUID PRIMARY KEY,        -- lấy nguyên từ client, KHÔNG tự sinh
    location        GEOGRAPHY(POINT, 4326) NOT NULL,
    need_type       VARCHAR(20) NOT NULL,
    people_count    INT NOT NULL DEFAULT 1,
    note            TEXT,
    sync_status     VARCHAR(20) NOT NULL DEFAULT 'SYNCED',
    created_at      TIMESTAMPTZ NOT NULL,
    synced_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_sos_requests_location ON sos_requests USING GIST (location);
```

Dùng `GEOGRAPHY(POINT, 4326)` chứ không phải `GEOMETRY` — vì
`GEOGRAPHY` tính khoảng cách theo mét trên bề mặt cầu (chính xác cho
khoảng cách thực tế), còn `GEOMETRY` tính theo đơn vị toạ độ phẳng (sai
lệch nếu không tự xử lý phép chiếu). Truy vấn "SOS trong bán kính X km":

```sql
SELECT * FROM sos_requests
WHERE ST_DWithin(location, ST_MakePoint(:lng, :lat)::geography, :radius_meters)
ORDER BY location <-> ST_MakePoint(:lng, :lat)::geography;
```

Dùng `hibernate-spatial` + `org.locationtech.jts.geom.Point` ở tầng JPA
entity — không tự parse WKT thủ công.

## API convention

- Toàn bộ endpoint dưới `/api/v1/`.
- Request ghi (POST SOS) nhận `id` từ client, dùng `INSERT ... ON CONFLICT
  (id) DO NOTHING` hoặc kiểm tra tồn tại trước — không để lỗi 500 khi
  client retry gửi lại request đã sync thành công trước đó (do không nhận
  được response vì mạng đứt giữa chừng).
- Response lỗi mạng/timeout phía backend cần trả nhanh — client có
  `receiveTimeout` ngắn (15s), không thiết kế endpoint xử lý nặng đồng bộ.
  Việc nặng (matching, gửi thông báo đội cứu hộ) đẩy qua queue xử lý bất
  đồng bộ (Spring `@Async` hoặc queue nhẹ), trả 202 Accepted ngay.

## Triển khai

VPS đặt ngoài Việt Nam hoặc multi-region (xem `docs/DECISIONS.md` mục 5).
Không giả định backend luôn khả dụng — đây là hệ thống đồng bộ phụ trợ,
KHÔNG phải điểm chịu lỗi duy nhất (single point of failure) của toàn bộ
trải nghiệm SOS.
