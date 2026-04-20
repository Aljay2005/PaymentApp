import 'package:flutter/material.dart';
import 'screens/product_page.dart';

void main() => runApp(const PaymentApp());

class PaymentApp extends StatelessWidget {
  const PaymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Payment App',
      debugShowCheckedModeBanner: true,
      theme: ThemeData.dark(useMaterial3: true),
      home: const ProductPage(),
    );
  }
}