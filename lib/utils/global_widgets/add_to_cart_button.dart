import 'package:flutter/material.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.count,
    this.onTap,
    this.onAddTap,
    this.onRemoveTap,
    this.width = 100,
    this.height = 40,
    this.label,
  });
  final int count;
  final double height;
  final double width;
  final String? label;
  final void Function()? onTap;
  final void Function()? onAddTap;
  final void Function()? onRemoveTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: count == 0 ? onTap : null,
      borderRadius: BorderRadius.circular(10),
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(10),
        child: Material(
          child: Ink(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: count == 0 ? Theme.of(context).primaryColor : null,
              border: count == 0
                  ? null
                  : Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
                child: count == 0
                    ? addToCartChild(context)
                    : addRemoveButtons(context)),
          ),
        ),
      ),
    );
  }

  Row addRemoveButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ColoredAddButton(
            onTap: onRemoveTap,
            icon: Icons.remove,
          ),
        ),
        Expanded(
          child: Text(
            textAlign: TextAlign.center,
            count.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ColoredAddButton(
            onTap: onAddTap,
            icon: Icons.add,
          ),
        ),
      ],
    );
  }

  Text addToCartChild(BuildContext context) {
    return Text(
      label ?? 'Add to cart',
      style:
          Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
    );
  }
}

class ColoredAddButton extends StatelessWidget {
  const ColoredAddButton({
    super.key,
    required this.onTap,
    this.icon,
  });

  final void Function()? onTap;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
