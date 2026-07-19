// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sos_request_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SosRequestDtoAdapter extends TypeAdapter<SosRequestDto> {
  @override
  final int typeId = 1;

  @override
  SosRequestDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SosRequestDto(
      id: fields[0] as String,
      latitude: fields[1] as double,
      longitude: fields[2] as double,
      needType: fields[3] as String,
      peopleCount: fields[4] as int,
      note: fields[5] as String?,
      createdAt: fields[6] as String,
      syncStatus: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SosRequestDto obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.needType)
      ..writeByte(4)
      ..write(obj.peopleCount)
      ..writeByte(5)
      ..write(obj.note)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.syncStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SosRequestDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SosRequestDto _$SosRequestDtoFromJson(Map<String, dynamic> json) =>
    SosRequestDto(
      id: json['id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      needType: json['needType'] as String,
      peopleCount: (json['peopleCount'] as num).toInt(),
      note: json['note'] as String?,
      createdAt: json['createdAt'] as String,
      syncStatus: json['syncStatus'] as String,
    );

Map<String, dynamic> _$SosRequestDtoToJson(SosRequestDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'needType': instance.needType,
      'peopleCount': instance.peopleCount,
      'note': instance.note,
      'createdAt': instance.createdAt,
      'syncStatus': instance.syncStatus,
    };
