import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../core/constants/color_constants.dart';
import 'elevated_card.dart';

class BillDetailsCard extends StatelessWidget {
  const BillDetailsCard({
    super.key,
    required this.totalItems,
    required this.subtotal,
    required this.deliveryCharge,
    required this.discount,
  });
  final int? totalItems;
  final double? subtotal;
  final double? deliveryCharge;
  final double? discount;
  @override
  Widget build(BuildContext context) {
    return ElevatedCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bill details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 10),
          BillDetailsAmountRow(
            icon: Iconsax.note_1_bold,
            title: 'Subtotal ($totalItems items)',
            subtitle: '₹${subtotal?.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 15),
          const BillDetailsAmountRow(
            icon: Iconsax.truck_fast_bold,
            title: 'Delivery charge',
            subtitle: '₹20.00',
          ),
          if (discount != null) ...[
            const SizedBox(height: 15),
            BillDetailsAmountRow(
              icon: Iconsax.discount_shape_bold,
              title: 'Discount',
              subtitle: '-₹${discount?.toStringAsFixed(2) ?? '-'}',
            ),
          ],
          const SizedBox(height: 20),
          const DottedLine(
            dashColor: ColorConstants.hintColor,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              Text(
                '₹${((subtotal ?? 0) + (deliveryCharge ?? 0) - (discount ?? 0)).toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

class BillDetailsAmountRow extends StatelessWidget {
  const BillDetailsAmountRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String title, subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: ColorConstants.hintColor,
        ),
        const SizedBox(width: 5),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: ColorConstants.hintColor),
        ),
        const Spacer(),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorConstants.primaryBlack,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
