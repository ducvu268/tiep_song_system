import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tiep_song/common/config/app_config.dart';
import 'package:tiep_song/common/errors/app_exception.dart';

@lazySingleton
class ApiClient {
  late final Dio dio;

  ApiClient(AppConfig config) {
    dio = Dio(
      BaseOptions(
        baseUrl: config.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        // Timeout nhận ngắn có chủ ý: trong lúc thiên tai, mạng thường
        // chập chờn — thà fail nhanh và để dữ liệu nằm lại hàng đợi local,
        // còn hơn app treo chờ 1 request trong khi user cần thao tác khác.
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    dio.interceptors.add(
      PrettyDioLogger(requestBody: true, responseBody: true),
    );
  }

  Future<Response<T>> post<T>(String path, {Object? data}) async {
    try {
      return await dio.post<T>(path, data: data);
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Lỗi kết nối server',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? query}) async {
    try {
      return await dio.get<T>(path, queryParameters: query);
    } on DioException catch (e) {
      throw ServerException(
        e.message ?? 'Lỗi kết nối server',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
