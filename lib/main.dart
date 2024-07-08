import 'package:flutter/material.dart';
import 'package:fruit_provider/controller/cart_provider.dart';
import 'package:fruit_provider/pages/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.pink,
                centerTitle: true,
                titleSpacing: 3,
                iconTheme: IconThemeData(color: Colors.white))),
        home: Home(),
      ),
    );
  }
}
