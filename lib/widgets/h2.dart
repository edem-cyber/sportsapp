import 'package:flutter/material.dart';
import 'package:sportsapp/helper/constants.dart';

class H2 extends StatelessWidget {
  final String? text;
  const H2({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: const TextStyle(
          fontSize: 20, color: kBlack, fontWeight: FontWeight.w900),
    );
  }
}
