import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/core/constants/color_constants.dart';

class OfferTag extends StatelessWidget {
  const OfferTag({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomPath(),
      child: Container(
        color: ColorConstants.primaryWhite,
        padding: const EdgeInsets.all(1).copyWith(top: 0),
        child: ClipPath(
          clipper: CustomPath(),
          child: Container(
            decoration: BoxDecoration(
              // color: ColorConstants.primaryGreen,
              gradient: LinearGradient(
                colors: [
                  ColorConstants.primaryGreen.withBlue(150),
                  ColorConstants.primaryGreen,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.all(5),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ColorConstants.primaryWhite,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var factor = (size.width) / 6;
    path.quadraticBezierTo(factor, factor * 2, 0, size.height);
    // path.lineTo(0, 0);
    // path.lineTo(2, 2);
    // path.lineTo(2, size.height);

    path.relativeLineTo(factor, -factor);
    path.relativeLineTo(factor, factor);
    path.relativeLineTo(factor, -factor);
    path.relativeLineTo(factor, factor);
    path.relativeLineTo(factor, -factor);

    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(size.width - factor, factor * 2, size.width, 0);
    // path.lineTo(size.width - 2, 2);
    // path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
