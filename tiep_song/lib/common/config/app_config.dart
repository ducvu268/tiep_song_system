/// Đọc từ file .env (flutter_dotenv) — KHÔNG hardcode API key trong code.
/// .env.example đi kèm repo, .env thật thì .gitignore.
///
/// Đăng ký thủ công vào getIt ở `bootstrap.dart` (không dùng @lazySingleton)
/// vì cần đọc xong dotenv TRƯỚC khi injectable's getIt.init() chạy — các
/// class khác (ApiClient, MeshService) phụ thuộc AppConfig qua constructor.
class AppConfig {
  final String apiBaseUrl;
  final String bridgefyApiKey;

  AppConfig({required this.apiBaseUrl, required this.bridgefyApiKey});
}
