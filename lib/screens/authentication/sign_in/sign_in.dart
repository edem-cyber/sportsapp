import 'package:flutter/material.dart';
import 'package:sportsapp/screens/authentication/sign_in/components/body.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);
  static const routeName = '/sign-in';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Body(),
    );
  }
}
