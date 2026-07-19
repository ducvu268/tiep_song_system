import 'package:intl/intl.dart';
import 'package:tiep_song/features/sos/domain/models/sos_request.dart';

/// Dựng nội dung text để chia sẻ 1 SOS request qua SMS/Zalo/email — dùng khi
/// người đang cầm máy bắt được sóng và muốn báo thủ công cho chính quyền/Hội
/// Chữ thập đỏ, kể cả khi họ không có tích hợp API nhận trực tiếp từ backend
/// (xem docs/DECISIONS.md mục 1).
String buildSosShareText(SosRequest request) {
  final mapsUrl =
      'https://maps.google.com/?q=${request.latitude},${request.longitude}';
  final buffer = StringBuffer()
    ..writeln('[SOS - Tiếp Sóng]')
    ..writeln('Mức độ: ${request.needType.label}')
    ..writeln('Số người cần cứu: ${request.peopleCount}');

  if (request.contactName != null && request.contactName!.isNotEmpty) {
    buffer.writeln('Người gửi: ${request.contactName}');
  }
  if (request.contactPhone != null && request.contactPhone!.isNotEmpty) {
    buffer.writeln('SĐT liên hệ: ${request.contactPhone}');
  }

  buffer
    ..writeln(
      'Toạ độ: ${request.latitude.toStringAsFixed(6)}, ${request.longitude.toStringAsFixed(6)}',
    )
    ..writeln('Xem bản đồ: $mapsUrl')
    ..writeln(
      'Thời gian gửi: ${DateFormat('HH:mm dd/MM/yyyy').format(request.createdAt)}',
    );

  if (request.note != null && request.note!.isNotEmpty) {
    buffer.writeln('Ghi chú: ${request.note}');
  }

  return buffer.toString().trim();
}
