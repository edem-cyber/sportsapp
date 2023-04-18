//auth wrapper
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/base.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/screens/authentication/sign_in/sign_in.dart';

class AuthWrapper extends StatelessWidget {
  static const String routeName = '/';
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //auth provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return StreamBuilder(
      stream: authProvider.authState,
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null || user.isAnonymous) {
            return const SignIn();
          }
          return const Base();
        }
        return const Scaffold(
          body: Center(
            child: CupertinoActivityIndicator(),
          ),
        );
      },
    );
  }
}