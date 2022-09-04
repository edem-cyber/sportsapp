import 'package:flutter/material.dart';
import 'package:sportsapp/screens/privacy_policy/widgets/body.dart';

class PrivacyPolicy extends StatelessWidget {
  //routename
  static const routeName = '/privacy_policy';
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text("Privacy Policy"),
      ),
      body: const SafeArea(child: Body()),
    );
  }
}
