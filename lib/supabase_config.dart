import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'https://jbtttpbvpucdaiynzwih.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpidHR0cGJ2cHVjZGFpeW56d2loIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI2NTA4MzgsImV4cCI6MjA2ODIyNjgzOH0.ApkALdnxZBgKp4jnHXuM_VuMk-QPR2rlPrZ7xDVkfyQ';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      debug: true,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}

