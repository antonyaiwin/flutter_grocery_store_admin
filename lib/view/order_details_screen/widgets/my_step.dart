import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';

class MyStep extends StatelessWidget {
  const MyStep({
    super.key,
    required this.title,
    required this.subtitle,
    this.isLast = false,
    this.isFirst = false,
    required this.isCompleted,
  });

  final String title;
  final String? subtitle;
  final bool isFirst;
  final bool isLast;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    Color color = isCompleted
        ? ColorConstants.primaryColor
        : ColorConstants.hintColor.withOpacity(0.25);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          children: [
            if (!isFirst)
              SizedBox(
                height: 10,
                child: VerticalDivider(
                  color: color,
                  thickness: 3,
                ),
              ),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 5),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(isCompleted ? 0.25 : 0.1),
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 22,
              child: isLast
                  ? null
                  : VerticalDivider(
                      indent: 5,
                      color: color,
                      thickness: 3,
                    ),
            ),
          ],
        ),
        Text.rich(
          TextSpan(
            text: title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isCompleted ? null : ColorConstants.hintColor,
                  height: 1.3,
                ),
            children: [
              TextSpan(
                text: subtitle != null ? '\n$subtitle' : '\n---',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ColorConstants.hintColor,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
