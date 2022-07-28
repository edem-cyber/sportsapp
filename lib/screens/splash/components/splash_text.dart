import 'package:flutter/material.dart';
import 'package:sportsapp/helper/constants.dart';

class SplashText extends StatelessWidget {
  const SplashText({Key? key, this.text, this.color}) : super(key: key);
  final String? text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(text!,
        style: const TextStyle(
          color: kWhite,
        ));
  }
}
