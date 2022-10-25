import 'package:flutter/material.dart';
import 'package:sportsapp/screens/bookmarks/widgets/body.dart';

class Bookmarks extends StatelessWidget {
  //routename
  static const routeName = '/bookmarks';
  const Bookmarks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text("Bookmarks"),
      ),
      body: const Body(),
    );
  }
}
