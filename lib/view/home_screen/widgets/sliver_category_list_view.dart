import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/controller/screens/add_category_screen_controller.dart';
import 'package:flutter_grocery_store_admin/controller/firebase/firestore_controller.dart';
import 'package:flutter_grocery_store_admin/utils/global_widgets/category_card.dart';
import 'package:flutter_grocery_store_admin/utils/global_widgets/elevated_card.dart';
import 'package:flutter_grocery_store_admin/view/add_category_screen/add_category_screen.dart';
import 'package:provider/provider.dart';

class SliverCategoryListView extends StatelessWidget {
  const SliverCategoryListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 150,
        child: Consumer<FireStoreController>(
          builder: (BuildContext context, value, Widget? child) =>
              ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ElevatedCard(
                  height: 100,
                  width: 100,
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider<
                              AddCategoryScreenController>(
                            create: (BuildContext context) =>
                                AddCategoryScreenController(
                                    context.read<FireStoreController>()),
                            child: const AddCategoryScreen(),
                          ),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Expanded(
                            child: Icon(
                              Icons.add_circle_outline,
                              size: 30,
                            ),
                          ),
                          Text(
                            'Add Category',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              var e = value.categoryList[index - 1];
              return CategoryCard(item: e);
            },
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemCount: value.categoryList.length + 1,
          ),
        ),
      ),
    );
  }
}
