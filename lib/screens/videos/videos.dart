import 'package:flutter/material.dart';
import 'package:sportsapp/screens/videos/widgets/body.dart';


class Videos extends StatelessWidget {
  //routename
  static const routeName = '/videos';
  const Videos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text("Videos"),
      ),
      body: const Body(),
    );
  }
}
