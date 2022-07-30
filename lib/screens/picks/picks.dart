import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/screens/picks/widgets/body.dart';

class Picks extends StatelessWidget {
  const Picks({Key? key}) : super(key: key);
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);

    // return Scaffold(
    //   appBar: AppBar(
    //     scrolledUnderElevation: 3,
    //     leading: CircleAvatar(
    //       // ignore: prefer_if_null_operators
    //       backgroundImage: NetworkImage(
    //           authProvider.user!.photoURL ?? AppImage.defaultProfilePicture),
    //       radius: 15,
    //     ),
    //     title: const Text('Home'),
    //   ),
    //   body: const Body(),
    // );
    return const Scaffold(
      body: Center(child: Text("Picks")),
    );
  }
}
