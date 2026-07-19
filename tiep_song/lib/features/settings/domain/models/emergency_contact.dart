import 'package:equatable/equatable.dart';

/// Thông tin liên hệ khẩn cấp của người dùng — nhập 1 lần trong màn Cài
/// đặt, đính kèm vào mọi SOS request gửi đi sau đó để đội cứu hộ/người
/// nhận biết đang liên hệ với ai.
class EmergencyContact extends Equatable {
  final String name;
  final String phone;

  const EmergencyContact({required this.name, required this.phone});

  @override
  List<Object?> get props => [name, phone];
}
