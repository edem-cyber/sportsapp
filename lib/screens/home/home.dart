import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/screens/authentication/sign_in/sign_in.dart';
import 'package:sportsapp/widgets/notification.dart';

class News extends StatelessWidget {
  const News({Key? key}) : super(key: key);
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // Text('Welcome ${authProvider.user!.username.toString()}'),
            ElevatedButton(
              child: const Text('Sign Out'),
              onPressed: () {
                authProvider.signOut();
              },
            ),
            ElevatedButton(
              child: Text('ISLOADING ${authProvider.isLoading}'),
              onPressed: () {
                print('ISLOADING ${authProvider.isLoading}');
                appNotification(
                    title: "isloading",
                    message: "${authProvider.isLoading}",
                    icon: const Icon(Icons.abc));
              },
            ),
          ],
        ),
      ),
    );
  }
}
