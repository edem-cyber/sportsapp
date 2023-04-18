import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/auth_wrapper.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/no_internet.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/LeaguesProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:firebase_core/firebase_core.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static GlobalKey mtAppKey = GlobalKey();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isInternetConnected = true;

  @override
  @override
  void initState() {
    super.initState();
    checkInternetConnectivity();
  }

  Future<void> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetConnected = false;
      });
    } else {
      setState(() {
        isInternetConnected = true;
      });
    }
  }

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
        ChangeNotifierProvider<LeaguesProvider>(
          create: (_) => LeaguesProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, ThemeProvider themeProvider, child) {
          return GetMaterialApp(
            key: MyApp.mtAppKey,
            navigatorKey: NavigationService.navigatorKey,
            title: 'Toppick',
            debugShowCheckedModeBanner: false,
            initialRoute: isInternetConnected
                ? AuthWrapper.routeName
                : NoInternetPage.routeName,
            //set theme preference from shared prefs
            routes: routes,
            theme: themeProvider.isDarkMode ? dark : light,
          );
        },
      ),
    );
  }
}
