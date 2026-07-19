# Tiếp Sóng — khung sườn Flutter

Tiếp Sóng — app cứu trợ thiên tai offline-first: gửi tín hiệu SOS qua Bluetooth mesh
(Bridgefy) khi mất sóng hoàn toàn, tự đồng bộ lên backend khi có mạng trở lại.

## Kiến trúc

Theo đúng convention Clean Architecture bạn đang dùng: mỗi feature có
`data / domain / presentation`, dùng BLoC + `get_it`/`injectable` cho DI.

```
lib/
  common/                     # hạ tầng dùng chung toàn app
    bloc/                     # BaseBloc, BaseState
    config/                   # AppConfig (đọc .env)
    di/                       # injector (get_it + injectable)
    errors/                   # AppException và các subclass
    logger/                   # AppLogger (talker)
    network/                  # ApiClient (Dio) — gọi backend khi có mạng
    services/
      mesh_service.dart       # bọc Bridgefy SDK — tầng vận chuyển offline
      location_service.dart   # GPS, hoạt động độc lập với sóng viễn thông
      connectivity_service.dart
    usecase/                  # base UseCase<Type, Params>

  features/
    sos/
      domain/
        models/               # SosRequest (entity thuần), ReliefNeedType
        repository/           # SosRepository (interface)
        usecases/             # SendSosUseCase, SyncPendingSosUseCase
      data/
        models/                       # SosRequestDto (Hive + json)
        datasources/
          sos_local_datasource.dart   # Hive — nguồn sự thật khi offline
          sos_mesh_datasource.dart    # parse payload qua/từ MeshService
          sos_remote_datasource.dart  # Dio -> Spring Boot API
        repositories/
          sos_repository_impl.dart    # chiến lược local-first, mesh-always,
                                       # server-when-possible
      presentation/
        bloc/                 # SosBloc
        screens/               # SosScreen (provider) + SosView (UI)
```

### Chiến lược dữ liệu — khác với `network-first` thông thường

Repository gốc bạn tham khảo dùng **network-first + cache fallback**
(gọi API trước, lỗi thì đọc cache cũ). App này đảo ngược hoàn toàn vì
network hiếm khi có sẵn trong tình huống thiên tai:

1. **Lưu Hive trước, luôn luôn** — không bao giờ mất dữ liệu người dùng
   vừa nhập, kể cả app bị kill ngay sau đó.
2. **Broadcast qua mesh ngay sau đó** — cố gắng hết sức, không throw nếu
   thất bại (không có ai trong tầm Bluetooth).
3. **Sync lên server khi có mạng** — chạy riêng, trigger bởi
   `ConnectivityService.onConnectivityChanged`, không chặn luồng chính.

## Setup

```bash
flutter pub get
cp .env.example .env   # rồi điền BRIDGEFY_API_KEY thật (đăng ký tại bridgefy.me)
dart run build_runner build --delete-conflicting-outputs
flutter run
```

`build_runner` sinh 2 loại file bắt buộc phải có trước khi build:
- `*.g.dart` cho `SosRequestDto` (Hive + json_serializable)
- `injector.config.dart` cho DI (injectable)

## Việc cần làm tiếp theo

- [ ] Đăng ký Bridgefy API key thật, test mesh giữa 2 thiết bị thật (giả lập
      không test được Bluetooth)
- [ ] Thêm `SyncPendingSosUseCase` trigger tự động qua
      `ConnectivityService.onConnectivityChanged` (hiện có usecase, chưa có
      nơi gọi tự động — cần 1 BackgroundSyncService hoặc lắng nghe ở app.dart)
- [ ] Thêm feature `relief_map` — hiển thị các SosRequest local + nhận từ
      mesh lên bản đồ
- [ ] Thêm go_router cho các màn hình còn lại
- [ ] Viết unit test cho `SosRepositoryImpl` (mock 3 datasource, test riêng
      từng nhánh: mesh thành công / mesh thất bại / sync server)
