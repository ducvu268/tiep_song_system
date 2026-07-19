import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

/// Theo dõi trạng thái mạng. App dùng service này để quyết định lúc nào nên
/// đẩy dữ liệu đã gom được (qua mesh, đang nằm trong Hive) lên backend —
/// KHÔNG dùng để quyết định có cho gửi SOS hay không, vì SOS luôn gửi được
/// qua mesh bất kể có mạng hay không.
@lazySingleton
class ConnectivityService {
  final _connectivity = Connectivity();

  Future<bool> get isOnline async {
    final results = await _connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  /// Stream để lắng nghe realtime — dùng để tự động trigger sync ngay khi
  /// thiết bị vừa bắt được sóng trở lại, không cần user tự bấm.
  Stream<bool> get onConnectivityChanged => _connectivity.onConnectivityChanged
      .map((results) => results.any((r) => r != ConnectivityResult.none));
}
