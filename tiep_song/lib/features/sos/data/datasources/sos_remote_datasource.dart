import 'package:injectable/injectable.dart';
import 'package:tiep_song/common/network/api_client.dart';
import 'package:tiep_song/features/sos/data/models/sos_request_dto.dart';

@injectable
class SosRemoteDataSource {
  final ApiClient _apiClient;

  SosRemoteDataSource(this._apiClient);

  /// POST /api/v1/sos — khớp với endpoint thiết kế ở bước Spring Boot.
  /// Idempotent theo `id` (uuid sinh ở client) để việc retry khi mạng chập
  /// chờn không tạo ra bản ghi trùng lặp ở backend.
  Future<void> submit(SosRequestDto dto) async {
    await _apiClient.post('/api/v1/sos', data: dto.toJson());
  }
}
