import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';

class HealthVerificationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> submitHealthCertification(
      String userId, Map<String, dynamic> data, String filePath) async {
    try {
      print('Starting health certification submission for user: $userId');

      final extension = filePath.split('.').last;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$userId/$timestamp.$extension';
      print('Preparing to upload file: $fileName');

      // Upload file
      await _supabase.storage.from(AppConfig.storageBucket).upload(
            fileName,
            File(filePath),
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );
      print('File uploaded successfully.');

      // Get file URL
      final fileUrl = await _supabase.storage
          .from(AppConfig.storageBucket)
          .createSignedUrl(fileName, 60 * 60 * 24 * 90);
      print('Signed URL created successfully.');

      // Store in database
      final response =
          await _supabase.from(AppConfig.healthCertificationsTable).insert({
        'user_id': userId,
        'data': data,
        'file_path': fileName,
        'file_url': fileUrl,
        'submitted_at': DateTime.now().toIso8601String(),
        'status': 'pending_review'
      }).select();

      if (response.isNotEmpty) {
        print('Certification submitted successfully. ID: ${response[0]['id']}');
        return response[0]['id'];
      } else {
        throw Exception('Failed to submit certification data');
      }
    } catch (e) {
      print('Error submitting certification: $e');
      throw Exception('Error submitting certification: $e');
    }
  }

  Future<Map<String, dynamic>?> getLatestCertification(String userId) async {
    try {
      final response = await _supabase
          .from('health_certifications')
          .select()
          .eq('user_id', userId)
          .order('submitted_at', ascending: false)
          .limit(1)
          .single();

      if (response != null) {
        // Get a fresh signed URL for the file
        final fileUrl = await _supabase.storage
            .from(AppConfig.storageBucket)
            .createSignedUrl(response['file_path'], 60 * 60 * 24); // 24 hours

        return {
          ...response,
          'file_url': fileUrl,
        };
      }
      return null;
    } catch (e) {
      print('Error fetching certification: $e');
      return null;
    }
  }

  Future<bool> verifyHealthStatus(String userId) async {
    try {
      final response = await _supabase
          .from('health_certifications')
          .select()
          .eq('user_id', userId)
          .eq('status', 'approved')
          .order('submitted_at', ascending: false)
          .limit(1)
          .single();

      if (response != null) {
        final submittedAt = DateTime.parse(response['submitted_at']);
        return DateTime.now().difference(submittedAt).inDays <= 90;
      }
      return false;
    } catch (e) {
      print('Error verifying health status: $e');
      return false;
    }
  }

  Future<String?> getLatestCertificationStatus(String userId) async {
    try {
      final response = await _supabase
          .from('health_certifications')
          .select('status')
          .eq('user_id', userId)
          .order('submitted_at', ascending: false)
          .limit(1)
          .single();

      return response != null ? response['status'] as String : null;
    } catch (e) {
      print('Error getting latest certification status: $e');
      return null;
    }
  }
}
