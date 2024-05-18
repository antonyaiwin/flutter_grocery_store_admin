import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/controller/screens/category_view_screen_controller.dart';
import 'package:flutter_grocery_store_admin/utils/global_widgets/my_network_image.dart';
import 'package:provider/provider.dart';

import '../../utils/global_widgets/product_card.dart';

class CategoryViewScreen extends StatelessWidget {
  const CategoryViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            MyNetworkImage(
                height: 50,
                width: 50,
                imageUrl: context
                        .read<CategoryViewScreenController>()
                        .category
                        .imageUrl ??
                    ''),
            const SizedBox(width: 10),
            Text(context.read<CategoryViewScreenController>().category.name ??
                ''),
          ],
        ),
      ),
      body: Consumer<CategoryViewScreenController>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (value.productList.isEmpty) {
            return const Center(
              child: Text('No data found!'),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(20).copyWith(bottom: 300),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 9 / 13,
            ),
            itemBuilder: (context, index) {
              var e = value.productList[index];
              return ProductCard(item: e);
            },
            itemCount: value.productList.length,
          );
        },
      ),
    );
  }
}
