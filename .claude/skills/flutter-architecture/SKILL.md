---
name: flutter-architecture
description: Dùng skill này bất cứ khi nào viết, sửa, hoặc review code Flutter trong dự án Tiếp Sóng — tạo feature mới, thêm bloc/usecase/repository, viết widget UI, hoặc setup dependency injection. Bắt buộc đọc trước khi tạo file .dart mới trong lib/.
---

# Flutter Architecture — Tiếp Sóng

Clean Architecture theo feature, đúc kết từ convention có sẵn của founder
(project `nbc-refmi-fabric-mobile-app`). Mọi code Flutter trong app này
PHẢI tuân theo, không tự sáng tạo pattern khác.

## Cấu trúc bắt buộc cho mỗi feature mới

```
lib/features/<feature_name>/
  domain/
    models/           # Entity thuần (extends Equatable), KHÔNG có annotation
                       # Hive/json — domain không phụ thuộc tầng data.
    repository/        # Abstract class — hợp đồng cho tầng data implement.
    usecases/           # implements UseCase<Type, Params>. Chỉ được gọi
                       # method trên Repository interface, KHÔNG import
                       # trực tiếp ApiClient/HiveService/MeshService.
  data/
    models/            # DTO — @HiveType + @JsonSerializable. Có
                       # fromDomain()/toDomain() để convert 2 chiều.
    datasources/       # 1 class riêng cho mỗi nguồn dữ liệu:
                       # *_local_datasource.dart (Hive)
                       # *_remote_datasource.dart (Dio -> Spring Boot)
                       # *_mesh_datasource.dart (MeshService, nếu feature
                       #   cần hoạt động offline)
    repositories/       # *_repository_impl.dart — @Injectable(as: XRepository).
                       # Đây là nơi CHỨA chiến lược offline/online, ghép
                       # nhiều datasource lại (xem docs/DECISIONS.md mục 3).
  presentation/
    bloc/               # *_bloc.dart + part 'event.dart' + part 'state.dart'.
                       # Bloc extends BaseBloc<Event, State>, dùng
                       # runSafely() cho mọi async handler.
                       #
                       # Feature có ≥2 bloc (ví dụ 1 bloc submit + 1 bloc
                       # xem list) → mỗi bloc 1 subfolder riêng theo tên màn
                       # hình: bloc/<screen_name>/*_bloc.dart. Feature chỉ
                       # có 1 bloc thì để phẳng, không cần subfolder.
    screens/            # Tách screen.dart (BlocProvider) / view.dart (UI
                       # thuần). Screen KHÔNG chứa logic, chỉ khởi tạo bloc
                       # qua getIt<XBloc>().
                       #
                       # Đồng bộ với bloc/ ở trên: ≥2 màn hình → mỗi màn
                       # 1 subfolder cùng tên: screens/<screen_name>/
                       # (screen.dart + view.dart). Giúp nhìn là biết ngay
                       # cặp bloc-screen nào đi với nhau (xem ví dụ
                       # `features/sos/presentation/` — subfolder `sos/` và
                       # `sos_list/` ở cả bloc/ lẫn screens/).
    widgets/            # Widget riêng của feature này, không dùng lại được
                       # ở feature khác. Nếu 1 widget xuất hiện ≥2 feature,
                       # chuyển lên common/widgets.
```

## Design system — LUÔN dùng lại, KHÔNG viết widget Material thô

Trước khi viết `ElevatedButton`, `CircularProgressIndicator`, `Scaffold`...
trực tiếp trong 1 screen, kiểm tra `lib/common/widgets/` đã có chưa:

| Thay vì viết thẳng            | Dùng                              |
|--------------------------------|------------------------------------|
| `Scaffold(...)`                | `AppScaffold(...)`                 |
| `ElevatedButton(...)`          | `AppButton.primary(...)` / `.outline(...)` / `.ghost(...)` |
| `CircularProgressIndicator()`  | `AppLoading()` / `AppLoading.overlay()` |
| Màu hardcode `Color(0xFF...)`  | `AppColor.primary`, `AppColor.textMuted`... (`common/constants/app_color.dart`) |
| `TextStyle(fontSize: ...)`     | `AppTextStyle.h1`, `.body`...      |
| Empty/error state tự vẽ        | `AppError(message: ..., onRetry: ...)` |

Nếu cần 1 widget chưa có (card, input, tag, status pill...), tạo mới trong
`common/widgets/` theo đúng pattern factory constructor như `AppButton`
(xem file đó làm mẫu), KHÔNG tạo trực tiếp trong feature trừ khi chắc chắn
chỉ dùng 1 lần.

## Bloc convention

```dart
@injectable
class XBloc extends BaseBloc<XEvent, XState> {
  XBloc({required XUseCase useCase}) : ... , super(const XState()) {
    on<XSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(XSubmitted event, Emitter<XState> emit) async {
    emit(state.copyWith(status: BaseStatus.loading));
    await runSafely(emit, () async {
      final result = await _useCase(params);
      emit(state.copyWith(status: BaseStatus.success, data: result));
    });
  }

  @override
  XState buildFailureState(String message) =>
      state.copyWith(status: BaseStatus.failure, errorMessage: message);
}
```

## DI

Mọi class cần inject: đánh dấu `@injectable` (transient), `@lazySingleton`
(1 instance sống suốt app — dùng cho service hạ tầng như `MeshService`,
`LocationService`), hoặc `@Injectable(as: XRepository)` (khi implement 1
interface). Sau khi thêm/sửa annotation, PHẢI chạy:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Ràng buộc riêng của app này (khác app thương mại thông thường)

- Bất kỳ luồng nào ghi dữ liệu người dùng nhập (đặc biệt SOS request) PHẢI
  ghi vào Hive local TRƯỚC, rồi mới thử gửi đi đâu khác. Không được throw
  exception làm mất dữ liệu đã nhập chỉ vì mesh/server thất bại.
- Test tính năng liên quan `bridgefy`/Bluetooth mesh CHỈ chạy được trên
  thiết bị thật (≥2 máy), không chạy được trên emulator/simulator.
- Màn hình liên quan hành động khẩn cấp (SOS, xác nhận cứu hộ) ưu tiên
  `AppButtonSize.large`, tương phản cao, tối thiểu thao tác — không áp
  dụng quy tắc "UI đẹp/nhiều bước xác nhận" như app thông thường.
