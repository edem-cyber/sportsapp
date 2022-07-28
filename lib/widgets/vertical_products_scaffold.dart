import 'package:flutter/material.dart';

class VerticalProductsScaffold extends StatelessWidget {
  final List<Widget> products;
  const VerticalProductsScaffold({Key? key, required this.products})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Wrap(
          // spacing: 2,
          runSpacing: 15,
          children: products,
        ),
      ),
    );
  }
}
