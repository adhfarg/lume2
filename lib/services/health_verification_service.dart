import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HealthVerificationService {
  final Dio _dio;

  HealthVerificationService()
      : _dio = Dio(BaseOptions(
          baseUrl: kReleaseMode
              ? 'https://your-production-server.com'
              : 'http://localhost:3000',
        ));

  Future<String> submitHealthCertification(
      String userId, Map<String, String> data) async {
    final response = await _dio.post('/health-certification', data: {
      'userId': userId,
      ...data,
    });
    return response.data['certificationId'];
  }
}
