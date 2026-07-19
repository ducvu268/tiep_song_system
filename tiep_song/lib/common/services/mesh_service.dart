import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bridgefy/bridgefy.dart';
import 'package:injectable/injectable.dart';
import 'package:tiep_song/common/errors/app_exception.dart';
import 'package:tiep_song/common/logger/app_logger.dart';

/// Bọc Bridgefy SDK thành 1 service duy nhất cho toàn app.
///
/// Vai trò: khi 1 gói tin (ví dụ SOS) được gửi qua [broadcast], Bridgefy sẽ
/// tự lo việc "nhảy" (relay) qua các thiết bị Bridgefy khác trong bán kính
/// Bluetooth, không cần internet. Đây là tầng vận chuyển — KHÔNG chứa logic
/// nghiệp vụ (không biết gì về "SOS request" là gì), chỉ biết gửi/nhận bytes.
///
/// Nghiệp vụ (parse SOS request từ bytes, lưu Hive...) nằm ở
/// `features/sos/data/datasources/sos_mesh_datasource.dart`.
@lazySingleton
class MeshService implements BridgefyDelegate {
  final _bridgefy = Bridgefy();
  final _incomingController = StreamController<Uint8List>.broadcast();
  final _connectedPeersController = StreamController<int>.broadcast();

  bool _isStarted = false;
  final Set<String> _connectedPeers = {};

  /// Stream phát ra dữ liệu thô mỗi khi nhận được gói tin từ mesh
  /// (từ hàng xóm trực tiếp HOẶC được relay qua nhiều hop).
  Stream<Uint8List> get incomingMessages => _incomingController.stream;

  /// Số lượng thiết bị Bridgefy đang kết nối trực tiếp (trong tầm Bluetooth).
  /// UI dùng để hiển thị "đang thấy X thiết bị gần đây" — cho user biết
  /// mesh có khả năng hoạt động hay không.
  Stream<int> get connectedPeerCount => _connectedPeersController.stream;

  Future<void> start({required String apiKey}) async {
    if (_isStarted) return;
    try {
      await _bridgefy.initialize(apiKey: apiKey, delegate: this);
      await _bridgefy.start(
        userId: null, // để SDK tự sinh UUID ổn định trên thiết bị
        propagationProfile: BridgefyPropagationProfile.highDensityNetwork,
      );
      _isStarted = true;
      AppLogger.info('MeshService: started');
    } catch (e) {
      throw MeshException('Không khởi động được mesh network: $e');
    }
  }

  /// Gửi broadcast — mọi thiết bị Bridgefy trong mạng lưới đều có thể nhận,
  /// tự relay giúp nếu không phải người nhận cuối. Dùng cho SOS vì ta không
  /// biết trước ai sẽ là "cầu nối ra ngoài" (thiết bị có sóng).
  Future<String> broadcast(Map<String, dynamic> payload) async {
    if (!_isStarted) {
      throw const MeshException('Mesh chưa được khởi động.');
    }
    final bytes = Uint8List.fromList(utf8.encode(jsonEncode(payload)));
    try {
      final currentUserID = await _bridgefy.currentUserID;
      final messageId = await _bridgefy.send(
        data: bytes,
        transmissionMode: BridgefyTransmissionMode(
          type: BridgefyTransmissionModeType.broadcast,
          uuid: currentUserID,
        ),
      );
      return messageId;
    } catch (e) {
      throw MeshException('Gửi qua mesh thất bại: $e');
    }
  }

  // --- BridgefyDelegate callbacks ---

  @override
  void bridgefyDidConnect({required String userID}) {
    _connectedPeers.add(userID);
    _connectedPeersController.add(_connectedPeers.length);
  }

  @override
  void bridgefyDidDisconnect({required String userID}) {
    _connectedPeers.remove(userID);
    _connectedPeersController.add(_connectedPeers.length);
  }

  @override
  void bridgefyDidReceiveData({
    required Uint8List data,
    required String messageId,
    required BridgefyTransmissionMode transmissionMode,
  }) {
    _incomingController.add(data);
  }

  @override
  void bridgefyDidSendMessage({required String messageID}) {
    AppLogger.info('MeshService: đã gửi thành công messageID=$messageID');
  }

  @override
  void bridgefyDidFailSendingMessage({
    required String messageID,
    BridgefyError? error,
  }) {
    AppLogger.warning(
        'MeshService: gửi thất bại messageID=$messageID ($error)');
  }

  @override
  void bridgefyDidStart({required String currentUserID}) {}

  @override
  void bridgefyDidFailToStart({required BridgefyError error}) {
    AppLogger.warning('MeshService: start thất bại ($error)');
  }

  @override
  void bridgefyDidStop() {}

  @override
  void bridgefyDidFailToStop({required BridgefyError error}) {
    AppLogger.warning('MeshService: stop thất bại ($error)');
  }

  @override
  void bridgefyDidDestroySession() {}

  @override
  void bridgefyDidFailToDestroySession() {
    AppLogger.warning('MeshService: destroy session thất bại');
  }

  @override
  void bridgefyDidEstablishSecureConnection({required String userID}) {}

  @override
  void bridgefyDidFailToEstablishSecureConnection({
    required String userID,
    required BridgefyError error,
  }) {
    AppLogger.warning(
      'MeshService: thiết lập kết nối bảo mật với $userID thất bại ($error)',
    );
  }

  @override
  void bridgefyDidSendDataProgress({
    required String messageID,
    required int position,
    required int of,
  }) {}
}
