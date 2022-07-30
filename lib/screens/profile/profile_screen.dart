import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/screens/authentication/sign_in/sign_in.dart';
import 'package:sportsapp/screens/profile/components/body.dart';

class Leagues extends StatefulWidget {
  static String routeName = "/profile";

  const Leagues({Key? key}) : super(key: key);

  @override
  State<Leagues> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Leagues> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              try {
                await authProvider.signOut();
                //if mounted
                // if (!mounted) return;
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (_) => const SignIn(), fullscreenDialog: true));
              } catch (e) {
                debugPrint(e.toString());
              }
            },
          ),
        ],
      ),
      body: const Body(),
    );
  }
}
