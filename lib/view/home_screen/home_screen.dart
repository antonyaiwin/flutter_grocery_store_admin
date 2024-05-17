import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/controller/screens/home_screen_controller.dart';
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
    );
  }
}
