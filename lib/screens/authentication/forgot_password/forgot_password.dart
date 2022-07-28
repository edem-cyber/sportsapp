import 'package:flutter/material.dart';
import 'package:sportsapp/screens/authentication/forgot_password/components/body.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);
  static const routeName = '/forgot-password';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Body());
  }
}
