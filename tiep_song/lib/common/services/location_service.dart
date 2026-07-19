import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:tiep_song/common/errors/app_exception.dart';

/// Lấy toạ độ GPS. GPS hoạt động độc lập với sóng viễn thông/internet nên
/// vẫn dùng được ngay cả khi mất mạng hoàn toàn — chỉ cần vệ tinh.
@lazySingleton
class LocationService {
  Future<Position> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException('GPS đang tắt. Vui lòng bật định vị.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationException('Ứng dụng cần quyền vị trí để gửi SOS.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'Quyền vị trí bị từ chối vĩnh viễn. Vào Cài đặt để bật lại.',
      );
    }

    try {
      // timeLimit ngắn + accuracy vừa phải: trong tình huống khẩn cấp,
      // có toạ độ tương đối nhanh quan trọng hơn độ chính xác tuyệt đối.
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
    } catch (e) {
      // Fallback: dùng vị trí biết gần nhất nếu lấy vị trí mới thất bại
      // (ví dụ trong nhà, tín hiệu vệ tinh yếu).
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) return last;
      throw LocationException('Không lấy được vị trí: $e');
    }
  }
}
