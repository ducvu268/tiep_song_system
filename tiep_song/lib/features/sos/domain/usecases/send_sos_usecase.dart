import 'package:injectable/injectable.dart';
import 'package:tiep_song/common/usecase/usecase.dart';
import 'package:tiep_song/features/sos/domain/models/relief_need_type.dart';
import 'package:tiep_song/features/sos/domain/models/sos_request.dart';
import 'package:tiep_song/features/sos/domain/repository/sos_repository.dart';

class SendSosParams {
  final double latitude;
  final double longitude;
  final ReliefNeedType needType;
  final int peopleCount;
  final String? note;

  const SendSosParams({
    required this.latitude,
    required this.longitude,
    required this.needType,
    required this.peopleCount,
    this.note,
  });
}

@injectable
class SendSosUseCase implements UseCase<SosRequest, SendSosParams> {
  final SosRepository _repository;

  SendSosUseCase(this._repository);

  @override
  Future<SosRequest> call(SendSosParams params) => _repository.createSos(
    latitude: params.latitude,
    longitude: params.longitude,
    needType: params.needType,
    peopleCount: params.peopleCount,
    note: params.note,
  );
}
