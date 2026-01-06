import 'package:get/get.dart';
import 'package:vp_family/utils/shared_pref.dart';

class SplashController extends GetxController {
  /// Returns true if logged in
  Future<bool> checkLogin() async {
    bool? isLoggedIn = await getSavedObject("login"); // nullable
    return isLoggedIn ?? false; // default to false if null
  }
}
