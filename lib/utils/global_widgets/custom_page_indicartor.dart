import 'package:flutter/material.dart';

import '../../core/constants/color_constants.dart';

class CustomPageIndicator extends StatelessWidget {
  const CustomPageIndicator(
      {super.key, required this.count, required this.pageIndex});
  final int count;
  final int pageIndex;
  final double activeRadius = 3.2;
  final double unActiveRadius = 2.5;
  final double endRadius = 1.5;
  final double hiddenRadius = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: getPadding(index)),
          child: CircleAvatar(
            radius: pageIndex == index ? activeRadius : getRadius(index),
            backgroundColor:
                pageIndex == index ? ColorConstants.primaryBlue : null,
          ),
        );
      }),
    );
  }

  double getRadius(int index) {
    int smallDotWeight = 0;
    if (pageIndex == 0 || pageIndex == count - 1) {
      smallDotWeight = 5;
    } else if (pageIndex == 1 || pageIndex == count - 2) {
      smallDotWeight = 4;
    } else if (pageIndex == 2 || pageIndex == count - 3) {
      smallDotWeight = 3;
    } else if (pageIndex == 3 || pageIndex == count - 4) {
      smallDotWeight = 2;
    }

    if (pageIndex - 2 <= 0) {
      if (index < pageIndex) {
        return unActiveRadius;
      } else if (index == pageIndex + smallDotWeight) {
        return endRadius;
      } else if (index > pageIndex + smallDotWeight - 1) {
        return hiddenRadius;
      }
    } else if (pageIndex + 2 >= count - 1) {
      if (index > pageIndex) {
        return unActiveRadius;
      } else if (index == pageIndex - smallDotWeight) {
        return endRadius;
      } else if (index < pageIndex - smallDotWeight) {
        return hiddenRadius;
      }
    } else if (index == pageIndex - 3 || index == pageIndex + 3) {
      return endRadius;
    } else if (index < pageIndex - 3 || index > pageIndex + 3) {
      return hiddenRadius;
    }
    return unActiveRadius;
  }

  double getPadding(int index) {
    return getRadius(index) == 0 ? 0 : 2;
  }

// old method when developing algorithm
  /* double getPadding(int index) {
    if (pageIndex - 6 >= index || pageIndex + 6 <= index) {
      return 0;
    }
    return 2;
  } */

// old method when developing algorithm
  /* double getradius(int index) {
    // if (pageIndex - 2 > index || pageIndex + 2 < index) {
    //   if (pageIndex - 5 == index || pageIndex + 5 == index) {
    //     return 1.5;
    //   } else if (pageIndex - 5 > index || pageIndex + 5 < index) {
    //     return 0;
    //   } else if (pageIndex - 2 <= 0 || pageIndex + 2 >= count - 1) {
    //     return 0;
    //   }
    //   return 2.5;
    // } else {
    //   return 2.5;
    // }

    // double mid = count / 2;

    int smallDotWeight = 3;
    if (pageIndex == 0) {
      smallDotWeight = 2;
    } else if (pageIndex == 1) {
      smallDotWeight = 1;
    } else if (pageIndex == 2) {
      smallDotWeight = 0;
    } else if (pageIndex - 2 <= 0) {
      if (index < pageIndex) {
        return 4;
      } else if (index == pageIndex + smallDotWeight) {
        return 1.5;
      } else if (index > pageIndex + smallDotWeight - 1) {
        return 0;
      }
    } else if (pageIndex + 2 >= count - 1) {
      if (index > pageIndex) {
        return 4;
      } else if (index == pageIndex - smallDotWeight) {
        return 1.5;
      } else if (index < pageIndex - smallDotWeight - 1) {
        return 0;
      }
    }
    return 5;

    // if (pageIndex - 6 >= index || pageIndex + 6 <= index) {
    //   return 0;
    // } else if (pageIndex - 5 >= index || pageIndex + 5 <= index) {
    //   return 1.5;
    // }
    // return 2.5;
  } */
}
