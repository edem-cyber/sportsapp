import 'package:flutter/material.dart';
import 'package:sportsapp/screens/authentication/sign_up/components/body.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);
  static const routeName = '/sign-up';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Body());
  }
}
