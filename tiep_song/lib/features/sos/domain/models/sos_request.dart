import 'package:equatable/equatable.dart';
import 'package:tiep_song/features/sos/domain/models/relief_need_type.dart';

/// Entity thuần của tầng Domain. KHÔNG có annotation Hive/json — những thứ
/// đó thuộc tầng Data (xem `data/models/sos_request_dto.dart`).
class SosRequest extends Equatable {
  final String id; // uuid sinh tại client, dùng để idempotent khi sync
  final double latitude;
  final double longitude;
  final ReliefNeedType needType;
  final int peopleCount;
  final String? note;
  final DateTime createdAt;
  final SosSyncStatus syncStatus;

  const SosRequest({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.needType,
    required this.peopleCount,
    this.note,
    required this.createdAt,
    required this.syncStatus,
  });

  SosRequest copyWith({SosSyncStatus? syncStatus}) => SosRequest(
    id: id,
    latitude: latitude,
    longitude: longitude,
    needType: needType,
    peopleCount: peopleCount,
    note: note,
    createdAt: createdAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );

  @override
  List<Object?> get props => [
    id,
    latitude,
    longitude,
    needType,
    peopleCount,
    note,
    createdAt,
    syncStatus,
  ];
}
