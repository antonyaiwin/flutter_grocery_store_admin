import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/core/constants/color_constants.dart';
import 'package:flutter_grocery_store_admin/utils/global_widgets/my_network_image.dart';

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
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: ColorConstants.primaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(radius ?? 22),
      ),
      child: user?.photoURL != null
          ? MyNetworkImage(
              imageUrl: user!.photoURL!,
              height: (radius ?? 22) * 2,
              width: (radius ?? 22) * 2,
              fit: BoxFit.cover,
            )
          : user?.displayName == null
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
