import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';

class HealthVerificationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> _ensureStorageAccess() async {
    try {
      // Test storage access
      await _supabase.storage.getBucket(AppConfig.storageBucket);
    } catch (e) {
      if (e is StorageException && e.statusCode == 404) {
        // Bucket doesn't exist, try to create it
        try {
          await _supabase.storage.createBucket(
            AppConfig.storageBucket,
            const BucketOptions(
              public: false,
              fileSizeLimit: '5242880',
            ),
          );
        } catch (createError) {
          throw Exception('Failed to create storage bucket: $createError');
        }
      } else {
        throw Exception('Storage access error: $e');
      }
    }
  }

  Future<String> submitHealthCertification(
      String userId, Map<String, dynamic> data, String filePath) async {
    try {
      // Ensure storage access before proceeding
      await _ensureStorageAccess();

      // Create a unique file path
      final extension = filePath.split('.').last;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'certifications/$userId/$timestamp.$extension';

      // Upload file to Supabase storage
      await _supabase.storage.from(AppConfig.storageBucket).upload(
            fileName,
            File(filePath),
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      // Get the file URL
      final fileUrl = await _supabase.storage
          .from(AppConfig.storageBucket)
          .createSignedUrl(fileName, 60 * 60 * 24 * 90); // 90 days

      // Store certification data
      final response = await _supabase.from('health_certifications').insert({
        'user_id': userId,
        'data': data,
        'file_path': fileName,
        'file_url': fileUrl,
        'submitted_at': DateTime.now().toIso8601String(),
        'status': 'pending_review'
      }).select();

      if (response.isNotEmpty) {
        return response[0]['id'];
      } else {
        throw Exception('Failed to submit certification data');
      }
    } on StorageException catch (e) {
      print('Storage error details: ${e.message}, Status: ${e.statusCode}');
      throw Exception('Storage error: ${e.message}');
    } on PostgrestException catch (e) {
      print('Database error details: ${e.message}');
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
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
