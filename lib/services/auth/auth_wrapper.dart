import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../pages/home_page.dart';
import '../../pages/signin_signup_pages/signIn_page.dart';
import '../../supabase_config.dart';

class AuthWrapper extends StatelessWidget {
  AuthWrapper({super.key});

  final SupabaseClient supabase = SupabaseConfig.client;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session = snapshot.data?.session;
        if (session != null) {
          return HomePage();
        }
        return SignInPage();
      },
    );
  }
}