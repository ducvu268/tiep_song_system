import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tiep_song/features/sos/domain/models/relief_need_type.dart';
import 'package:tiep_song/features/sos/domain/models/sos_request.dart';

part 'sos_request_dto.g.dart';

/// DTO tầng Data — có annotation Hive (lưu local) và json (gửi API).
/// Tách khỏi [SosRequest] (domain) để tầng domain không phụ thuộc Hive/json.
///
/// LƯU Ý: cần chạy `dart run build_runner build --delete-conflicting-outputs`
/// để sinh `sos_request_dto.g.dart` trước khi build app — giống convention
/// hiện tại của bạn với json_annotation.
@HiveType(typeId: 1)
@JsonSerializable()
class SosRequestDto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double latitude;

  @HiveField(2)
  final double longitude;

  @HiveField(3)
  final String needType; // lưu String để Hive khỏi cần adapter riêng cho enum

  @HiveField(4)
  final int peopleCount;

  @HiveField(5)
  final String? note;

  @HiveField(6)
  final String createdAt; // ISO 8601

  @HiveField(7)
  final String syncStatus;

  SosRequestDto({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.needType,
    required this.peopleCount,
    this.note,
    required this.createdAt,
    required this.syncStatus,
  });

  factory SosRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SosRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SosRequestDtoToJson(this);

  factory SosRequestDto.fromDomain(SosRequest entity) => SosRequestDto(
    id: entity.id,
    latitude: entity.latitude,
    longitude: entity.longitude,
    needType: entity.needType.name,
    peopleCount: entity.peopleCount,
    note: entity.note,
    createdAt: entity.createdAt.toIso8601String(),
    syncStatus: entity.syncStatus.name,
  );

  SosRequest toDomain() => SosRequest(
    id: id,
    latitude: latitude,
    longitude: longitude,
    needType: ReliefNeedType.values.byName(needType),
    peopleCount: peopleCount,
    note: note,
    createdAt: DateTime.parse(createdAt),
    syncStatus: SosSyncStatus.values.byName(syncStatus),
  );
}
