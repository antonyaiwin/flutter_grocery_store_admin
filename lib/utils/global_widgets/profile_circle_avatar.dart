import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileCircleAvatar extends StatelessWidget {
  const ProfileCircleAvatar({
    super.key,
    this.radius,
    this.user,
  });
  final double? radius;
  final User? user;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage:
          user?.photoURL == null ? null : NetworkImage(user!.photoURL!),
      child: user?.photoURL != null || user?.displayName == null
          ? null
          : Center(
              child: Text(
                user?.displayName != null && user!.displayName!.isNotEmpty
                    ? user!.displayName![0]
                    : 'U',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
    );
  }
}
