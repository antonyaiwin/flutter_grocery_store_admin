import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/controller/add_product_screen_controller.dart';
import 'package:flutter_grocery_store_admin/controller/firebase/firestore_controller.dart';
import 'package:flutter_grocery_store_admin/controller/home_screen_controller.dart';
import 'package:flutter_grocery_store_admin/core/data/dummy_db.dart';
import 'package:flutter_grocery_store_admin/view/add_product_screen/add_product_screen.dart';
import 'package:provider/provider.dart';

import 'widgets/home_bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: context.read<HomeScreenController>().pageController,
        children: context.read<HomeScreenController>().pageList,
      ),
      bottomNavigationBar: const HomeBottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (BuildContext context) => AddProductScreenController(),
                child: const AddProductScreen(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
