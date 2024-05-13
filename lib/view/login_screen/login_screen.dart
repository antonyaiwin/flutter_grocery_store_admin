import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/controller/login_controller.dart';
import 'package:flutter_grocery_store_admin/core/constants/color_constants.dart';
import 'package:provider/provider.dart';

import '../../core/constants/image_constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    log('rebuild');
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(
                    MediaQuery.of(context).size.width / 2, 50),
                bottomRight: Radius.elliptical(
                    MediaQuery.of(context).size.width / 2, 50),
              ),
              child: Image.asset(ImageConstants.loginBanner),
            ),
            Form(
              key: context.read<LoginController>().formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Welcome!',
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller:
                          context.read<LoginController>().emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        isDense: true,
                      ),
                      validator: context.read<LoginController>().emailValidator,
                    ),
                    const SizedBox(height: 15),
                    Consumer<LoginController>(
                      builder: (BuildContext context, value, Widget? child) =>
                          TextFormField(
                        controller:
                            context.read<LoginController>().passwordController,
                        obscureText: value.obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          isDense: true,
                          suffixIcon: IconButton(
                            onPressed: () {
                              value.togglePasswordVisibility();
                            },
                            icon: Icon(
                              value.obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        validator:
                            context.read<LoginController>().passwordValidator,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Consumer<LoginController>(
                      builder: (BuildContext context, value, Widget? child) =>
                          InkWell(
                        onTap: value.loading
                            ? null
                            : () {
                                value.loginClicked(context);
                              },
                        borderRadius: BorderRadius.circular(50),
                        child: Ink(
                          width: double.infinity,
                          height: 50,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: value.loading
                                ? ColorConstants.primaryBlack.withOpacity(0.5)
                                : ColorConstants.primaryColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: value.loading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator())
                                : Text(
                                    'Login',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: ColorConstants.primaryWhite,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
