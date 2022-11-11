import 'package:flutter/material.dart';
import 'package:sportsapp/screens/settings/widgets/body.dart';

class SettingsPage extends StatelessWidget {
  //routename
  static const routeName = '/settings';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text("Settings"),
      ),
      body: const Body(),
    );
  }
}
