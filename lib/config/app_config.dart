class AppConfig {
  // Supabase configuration
  static const String supabaseUrl = 'https://fhorwkmnlrijxkodkwcx.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZob3J3a21ubHJpanhrb2Rrd2N4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMxNDM5NDksImV4cCI6MjA0ODcxOTk0OX0.b6PWrxywkjCO-zI9bhT9qL_jgNl9anqUATbGeMUOobM';

  // Storage configuration
  static const String storageBucket = 'health_certifications';
  static const String maxFileSize = '5242880'; // 5MB in bytes, as a string

  // Database configuration
  static const String healthCertificationsTable = 'health_certifications';

  // Health certification configuration
  static const int certificationValidityDays = 90;
}
