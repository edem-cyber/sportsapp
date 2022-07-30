import 'package:flutter/material.dart';
import 'package:sportsapp/base.dart';
import 'package:sportsapp/main.dart';
import 'package:sportsapp/screens/authentication/forgot_password/forgot_password.dart';
import 'package:sportsapp/screens/authentication/sign_in/sign_in.dart';
import 'package:sportsapp/screens/authentication/sign_up/sign_up.dart';
import 'package:sportsapp/screens/home/home.dart';
import 'package:sportsapp/screens/profile/profile_screen.dart';
import 'package:sportsapp/screens/splash/splash_screen.dart';
import 'package:sportsapp/screens/welcome/welcome.dart';

//declare all named routes here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  Base.routeName: (context) => const Base(),
  // AuthWrapper.routeName: (context) => const AuthWrapper(),
  SignIn.routeName: (context) => const SignIn(),
  SignUp.routeName: (context) => const SignUp(),
  News.routeName: (context) => const News(),
  Leagues.routeName: (context) => const Leagues(),
  Welcome.routeName: (context) => const Welcome(),
  ForgotPassword.routeName: (context) => const ForgotPassword(),
};
