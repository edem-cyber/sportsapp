import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/screens/profile/widgets/body.dart';

class Profile extends StatelessWidget {
  //routename
  static const routeName = '/profile';
  final String? id;
  const Profile({Key? key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: true);
    debugPrint("id: $id");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text("Profile"),
      ),
      body: Body(
        id: id ?? authProvider.user!.uid,
      ),
    );
  }
}
