import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/view/splash_screen/splash_screen.dart';

import '../utils/functions/functions.dart';

class LoginController extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool loading = false;

  String? emailValidator(String? value) {
    if (EmailValidator.validate(value ?? '')) {
      return null;
    } else {
      return 'Enter valid email address!';
    }
  }

  String? passwordValidator(String? value) {
    if (value == null || value.length < 8) {
      return 'Enter a valid password with minimum 8 characters!';
    } else if (value.length > 15) {
      return 'Enter a valid password with maximum 15 characters!';
    } else {
      return null;
    }
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  Future<void> loginClicked(BuildContext context) async {
    loading = true;
    notifyListeners();
    if (formKey.currentState!.validate()) {
      try {
        UserCredential user =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        if (context.mounted) {
          showSuccessSnackBar(context: context, content: 'Login successful.');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const SplashScreen(),
            ),
            (route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        log(e.code.toString());

        if (!context.mounted) {
          return;
        }
        String snackBarMessage = 'Something went wrong!';
        switch (e.code) {
          case 'invalid-credential':
            snackBarMessage = 'Entered Email or Password is incorrect!';
            log(snackBarMessage);
            break;
        }
        showErrorSnackBar(
          context: context,
          content: snackBarMessage,
        );
      }
      loading = false;
      notifyListeners();
    }
  }
}
