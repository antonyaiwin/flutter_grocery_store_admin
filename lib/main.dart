import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/controller/cart_controller.dart';
import 'package:flutter_grocery_store_admin/controller/firebase/firebase_storage_controller.dart';
import 'package:flutter_grocery_store_admin/controller/firebase/firestore_controller.dart';
import 'package:flutter_grocery_store_admin/controller/order/orders_controller.dart';
import 'package:flutter_grocery_store_admin/core/constants/color_constants.dart';
import 'package:flutter_grocery_store_admin/view/splash_screen/splash_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CartController(),
        ),
        ChangeNotifierProvider(
          create: (context) => FireStoreController(),
        ),
        ChangeNotifierProvider(
          create: (context) => FirebaseStorageController(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrdersController(context),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Grocery Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: ColorConstants.primaryColor,
            primary: ColorConstants.primaryColor,
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.ubuntuTextTheme(),
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          scaffoldBackgroundColor: ColorConstants.scaffoldBackgroundColor,
          appBarTheme: const AppBarTheme(
              backgroundColor: ColorConstants.scaffoldBackgroundColor),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
