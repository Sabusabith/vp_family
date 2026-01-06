import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:vp_family/utils/shared_pref.dart';

class LoginController extends GetxController {
  final emailcontroller = TextEditingController();
  final passcontroller = TextEditingController();
  RxBool isloading = false.obs;
  login(BuildContext context) async {
    if (emailcontroller.text.isEmpty || passcontroller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    isloading(true); // start loading

    await Future.delayed(const Duration(seconds: 2)); // simulate network call

    if (emailcontroller.text == 'user' && passcontroller.text == '123') {
      // Save login status
      await saveObject('login', true);

      isloading(false); // stop loading
      context.go('/home'); // navigate
    } else {
      isloading(false); // stop loading first

      // Show normal flutter snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
