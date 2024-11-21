import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HealthVerificationService {
  final Dio _dio;

  HealthVerificationService()
      : _dio = Dio(BaseOptions(
          baseUrl: 'http://localhost:3000',
          connectTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 3),
        ));

  Future<String> submitHealthCertification(
      String userId, Map<String, dynamic> data, String path) async {
    try {
      final response = await _dio.post(
        '/health-certification',
        data: {
          'userId': userId,
          'data': data,
          'documentPath': path,
        },
      );

      if (response.statusCode == 200) {
        return response.data['certificationId'] as String;
      } else {
        throw Exception('Failed to submit health certification');
      }
    } catch (e) {
      throw Exception('Error submitting health certification: $e');
    }
  }

  Future<bool> verifyHealthStatus(String userId) async {
    try {
      final response = await _dio.get('/health-status/$userId');
      return response.data['isVerified'] as bool;
    } catch (e) {
      throw Exception('Error verifying health status: $e');
    }
  }
}
