import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/controller/profile_screen_controller.dart';
import 'package:flutter_grocery_store_admin/core/constants/color_constants.dart';
import 'package:flutter_grocery_store_admin/utils/global_widgets/elevated_card.dart';
import 'package:flutter_grocery_store_admin/utils/global_widgets/profile_circle_avatar.dart';
import 'package:flutter_grocery_store_admin/view/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const SplashScreen(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  context.read<ProfileScreenController>().changeProfilePic();
                },
                child: Stack(
                  children: [
                    Consumer<ProfileScreenController>(
                      builder: (context, value, child) => ProfileCircleAvatar(
                        radius: 50,
                        user: value.currentUser,
                      ),
                    ),
                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: ElevatedCard(
                        padding: EdgeInsets.zero,
                        elevation: 1,
                        height: 30,
                        width: 30,
                        child: Icon(
                          Icons.edit,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    FirebaseAuth.instance.currentUser?.displayName ?? '',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser?.email ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorConstants.hintColor,
                        ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
