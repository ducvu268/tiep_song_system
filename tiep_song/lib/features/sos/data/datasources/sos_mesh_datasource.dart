import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:tiep_song/common/logger/app_logger.dart';
import 'package:tiep_song/common/services/mesh_service.dart';
import 'package:tiep_song/features/sos/data/models/sos_request_dto.dart';

/// Cầu nối giữa "SOS request" (nghiệp vụ) và "bytes qua Bluetooth"
/// (MeshService, không biết gì về nghiệp vụ). Chỗ này là nơi duy nhất biết
/// định dạng payload gửi qua mesh.
@injectable
class SosMeshDataSource {
  final MeshService _meshService;

  SosMeshDataSource(this._meshService);

  static const _payloadType = 'sos_request';

  Future<void> broadcast(SosRequestDto dto) async {
    await _meshService.broadcast({'type': _payloadType, 'data': dto.toJson()});
  }

  /// Lọc trong stream thô của MeshService ra đúng những gói tin là SOS
  /// request (mesh network trong tương lai có thể mang nhiều loại payload
  /// khác — ví dụ tin nhắn text, cập nhật trạng thái cứu hộ).
  Stream<SosRequestDto> get incoming => _meshService.incomingMessages
      .map((bytes) {
        try {
          final json = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
          if (json['type'] != _payloadType) return null;
          return SosRequestDto.fromJson(json['data'] as Map<String, dynamic>);
        } catch (e) {
          AppLogger.warning('Bỏ qua gói tin mesh không hợp lệ: $e');
          return null;
        }
      })
      .where((dto) => dto != null)
      .cast<SosRequestDto>();
}
