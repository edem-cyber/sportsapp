import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/base.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/LeaguesProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sportsapp/screens/authentication/sign_in/sign_in.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'routes.dart';
import 'firebase_options.dart';

// Import the generated file
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // setupLocator();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // SharedPreferences prefs = await SharedPreferences.getInstance();

  return runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static GlobalKey mtAppKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    // var themeProvider = Provider.of<ThemeProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<NavigationService>(
          create: (_) => NavigationService(),
        ),
        ChangeNotifierProvider<LeaguesProvider>(
            create: (_) => LeaguesProvider()),
        // ChangeNotifierProvider<BookmarkModel>(
        //   create: (_) => BookmarkModel(),
        // ),
        // ChangeNotifierProvider<CountriesProvider>(
        //   create: (_) => CountriesProvider(),
        // ),
        ChangeNotifierProvider<LeaguesProvider>(
          create: (_) => LeaguesProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, ThemeProvider themeProvider, child) {
          return GetMaterialApp(
            key: mtAppKey,
            navigatorKey: NavigationService.navigatorKey,
            title: 'Toppick',
            debugShowCheckedModeBanner: false,
            initialRoute: AuthWrapper.routeName,
            //set theme preference from shared prefs
            routes: routes,
            theme: themeProvider.isDarkMode ? dark : light,
          );
        },
      ),
    );
  }
}

//auth wrapper
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
