import 'package:flutter/material.dart';
import 'package:supabase_v/pages/Category_list.dart';
import 'package:supabase_v/pages/details_page.dart';
import 'package:supabase_v/pages/favorite_page.dart';
import 'package:supabase_v/pages/home_page.dart';
import 'package:supabase_v/pages/signin_signup_pages/SignUp_page.dart';
import 'package:supabase_v/pages/signin_signup_pages/signIn_page.dart';
import 'package:supabase_v/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(appBarTheme: AppBarTheme(elevation: 1)),
      debugShowCheckedModeBanner: false,
      initialRoute: SignInPage.routeName,
      routes: {
        HomePage.routName: (context) => HomePage(),
        FavoritesPage.routeName: (context) => FavoritesPage(),
        DetailsPage.routeName: (context) => DetailsPage(),
        SignInPage.routeName: (context) => SignInPage(),
        SignUpPage.routeName: (context) => SignUpPage(),
        CategoryList.routeName: (context) => CategoryList(),
      },
    );
  }
}
