import 'package:injectable/injectable.dart';
import 'package:tiep_song/common/usecase/usecase.dart';
import 'package:tiep_song/features/sos/domain/models/sos_request.dart';
import 'package:tiep_song/features/sos/domain/repository/sos_repository.dart';

/// Toàn bộ SOS request đang lưu local — của chính máy này và các request
/// nhận relay được từ mesh. Dùng cho màn hình danh sách/lịch sử.
@injectable
class GetSosHistoryUseCase implements UseCase<List<SosRequest>, NoParams> {
  final SosRepository _repository;

  GetSosHistoryUseCase(this._repository);

  @override
  Future<List<SosRequest>> call(NoParams params) => _repository.getAllLocal();
}
