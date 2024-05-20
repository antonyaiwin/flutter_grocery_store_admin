import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/controller/screens/add_category_screen_controller.dart';
import 'package:flutter_grocery_store_admin/controller/category/category_delete_controller.dart';
import 'package:flutter_grocery_store_admin/controller/firebase/firestore_controller.dart';
import 'package:flutter_grocery_store_admin/controller/screens/category_view_screen_controller.dart';
import 'package:flutter_grocery_store_admin/core/constants/color_constants.dart';
import 'package:flutter_grocery_store_admin/utils/functions/functions.dart';
import 'package:flutter_grocery_store_admin/view/add_category_screen/add_category_screen.dart';
import 'package:flutter_grocery_store_admin/view/category_view_screen/category_view_screen.dart';
import 'package:provider/provider.dart';

import '../../model/category_model.dart';
import 'elevated_card.dart';
import 'my_network_image.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.item,
    this.showMoreButton = false,
  });

  final CategoryModel item;
  final bool showMoreButton;

  @override
  Widget build(BuildContext context) {
    return ElevatedCard(
      elevation: 5,
      height: 150,
      width: 100,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) =>
                    CategoryViewScreenController(context, category: item),
                child: const CategoryViewScreen(),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    Expanded(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: MyNetworkImage(
                        imageUrl: item.imageUrl ?? '',
                        fit: BoxFit.contain,
                      ),
                    )),
                    Text(
                      item.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              if (showMoreButton)
                Positioned(
                  right: 0,
                  top: 0,
                  child: PopupMenuButton(
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        child: const Text('Edit'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (context) =>
                                    AddCategoryScreenController(
                                  context.read<FireStoreController>(),
                                  categoryModel: item,
                                ),
                                child: const AddCategoryScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                      PopupMenuItem(
                        child: const Text('Delete'),
                        onTap: () {
                          showDeleteDialog(context);
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ChangeNotifierProvider(
        create: (BuildContext context) =>
            CategoryDeleteController(category: item),
        child: AlertDialog(
          title: const Text('Delete?'),
          content: Consumer<CategoryDeleteController>(
            builder: (BuildContext context, value, Widget? child) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Are you sure to delete? \nThis can\'t be undone.'),
                if (value.deleteState == DeleteState.error)
                  const Text(
                    'Error occurred while deleting the category!',
                    style: TextStyle(
                      color: ColorConstants.snackBarErrorBackground,
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            Consumer<CategoryDeleteController>(
              builder: (BuildContext context, value, Widget? child) {
                if (value.deleteState == DeleteState.deleted) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    Navigator.pop(context);
                    showSuccessSnackBar(
                      context: context,
                      content:
                          'Category "${item.name ?? ''}" deleted successfully.',
                    );
                  });
                }
                return TextButton(
                  onPressed: value.deleteState == DeleteState.deleting
                      ? null
                      : () {
                          value.deleteCategory(context);
                        },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Yes'),
                      if (value.deleteState == DeleteState.deleting) ...[
                        const SizedBox(width: 5),
                        const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(),
                        ),
                      ]
                    ],
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('no'),
            ),
          ],
        ),
      ),
    );
  }
}
