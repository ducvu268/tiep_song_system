import 'package:injectable/injectable.dart';
import 'package:tiep_song/common/usecase/usecase.dart';
import 'package:tiep_song/features/sos/domain/models/sos_request.dart';
import 'package:tiep_song/features/sos/domain/repository/sos_repository.dart';

/// Lắng nghe realtime các SOS request nhận được từ mesh (relay từ thiết bị
/// khác) — để màn hình danh sách tự cập nhật ngay khi có ai đó gần mình
/// gửi tín hiệu, không cần refresh thủ công.
@injectable
class WatchIncomingSosUseCase implements StreamUseCase<SosRequest, NoParams> {
  final SosRepository _repository;

  WatchIncomingSosUseCase(this._repository);

  @override
  Stream<SosRequest> call(NoParams params) => _repository.incomingFromMesh;
}
