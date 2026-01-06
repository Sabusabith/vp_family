import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vp_family/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://htjhwwyrlhnfcstjywxp.supabase.co',
    anonKey: 'sb_publishable_aX1ffS0sLlwgbcByl2N0PA_Couzim9D',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      routerConfig: AppRoutes.router,

      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        primaryColor: const Color(0xFF4CAF50),

        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF4CAF50),
          elevation: 0,
          titleTextStyle: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        textTheme: GoogleFonts.latoTextTheme(),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFC107),
        ),
      ),
    );
  }
}
