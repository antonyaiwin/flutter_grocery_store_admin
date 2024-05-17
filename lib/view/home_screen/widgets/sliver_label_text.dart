import 'package:flutter/material.dart';

class SliverLabelText extends StatelessWidget {
  const SliverLabelText({
    super.key,
    required this.label,
    this.onSeeAllPressed,
  });
  final String label;
  final void Function()? onSeeAllPressed;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (onSeeAllPressed != null)
              TextButton(
                onPressed: onSeeAllPressed,
                child: const Text('See all'),
              ),
          ],
        ),
      ),
    );
  }
}
