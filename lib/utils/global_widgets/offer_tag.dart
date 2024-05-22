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
            decoration: const BoxDecoration(
              // color: ColorConstants.primaryGreen,
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(0, 255, 0, 1),
                  Color.fromRGBO(0, 200, 0, 1),
                  // const Color.fromRGBO(0, 150, 0, 1),
                  // const Color.fromRGBO(0, 100, 0, 1),
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
                    height: 0.9,
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
    var factor = (size.width) / 8;
    path.quadraticBezierTo(factor, factor * 2, 0, size.height);
    // path.lineTo(0, 0);
    // path.lineTo(2, 2);
    // path.lineTo(2, size.height);

    path.relativeLineTo(factor, -factor);
    path.relativeLineTo(factor, factor);
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
