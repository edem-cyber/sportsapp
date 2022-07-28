// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/screens/authentication/sign_in/sign_in.dart';

class NoAccountText extends StatelessWidget {
  //text
  String text;
  //onpress
  Function() press;
  //  NoAccountText({Key? key, required String text}) : super(key: key);
  NoAccountText({Key? key, required this.text, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}
