import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vp_family/utils/shared_pref.dart';
import 'package:vp_family/view/splash/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to home after 2 seconds

    final controller = Get.put(SplashController());

    // Navigate after 2 seconds
    Future.delayed(const Duration(seconds: 2), () async {
      bool isLoggedIn = await controller.checkLogin();

      if (isLoggedIn) {
        context.go('/home'); // Navigate to home
      } else {
        context.go('/login'); // Navigate to login
      }
    });
    return Scaffold(
      backgroundColor: const Color(0xFF4CAF50),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Family icon in a circular frame
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.family_restroom, // built-in family icon
                size: 70,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 24),

            // App Name
            Text(
              'VP Family',
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 8),

            // Optional subtitle
            Text(
              'Connect your family tree',
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.white70,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
