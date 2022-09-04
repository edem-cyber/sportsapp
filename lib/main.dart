import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/helper/storage_manage.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/CountryProvider.dart';
import 'package:sportsapp/providers/LeaguesProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sportsapp/screens/authentication/sign_in/sign_in.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/screens/splash/splash_screen.dart';
import 'providers/postprovider.dart';
import 'routes.dart';

// void main() {
//   //widget binding ensures that the app is not destroyed when the screen is rotated
//   WidgetsFlutterBinding.ensureInitialized();

//   runApp(MultiProvider(
//     providers: [
//       ChangeNotifierProvider(
//         create: (_) => ThemeProvider(),
//       ),
//       ChangeNotifierProvider(
//         create: (_) => AuthProvider(),
//       ),
//     ],
//     child: const MyApp(),
//   ));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (context, theme, child) {
//         return GetMaterialApp(
//           debugShowCheckedModeBanner: false,
//           theme: theme.getTheme(),
//           initialRoute: Base.routeName,
//           routes: routes,

//         );
//       },
//     );
//   }
// }

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => ThemeProvider(),
//       child: Consumer<ThemeProvider>(
//           builder: (context, ThemeProvider themeProvider, child) {
//         return MaterialApp(
//           title: 'Flutter Theme Provider',
//           theme: themeProvider.dark ? dark : light,
//           initialRoute: Base.routeName,
//           // home: Base(),
//         );
//       }),
//     );
//   }
// }

// // void main() {
// //   return runApp(ChangeNotifierProvider<ThemeProvider>(
// //     create: (_) => new ThemeProvider(),
// //     child: const MyApp(),
// //   ));
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Consumer<ThemeProvider>(
// //       builder: (context, theme, _) => MaterialApp(
// //         theme: theme.getTheme(),
// //         home: Scaffold(
// //           appBar: AppBar(
// //             title: const Text('Hybrid Theme'),
// //           ),
// //           body: Row(
// //             children: [
// //               Container(
// //                 child: FlatButton(
// //                   onPressed: () => {
// //                     print('Set Light Theme'),
// //                     theme.setLightMode(),
// //                   },
// //                   child: const Text('Set Light Theme'),
// //                 ),
// //               ),
// //               Container(
// //                 child: FlatButton(
// //                   onPressed: () => {
// //                     print('Set Dark theme'),
// //                     theme.setDarkMode(),
// //                   },
// //                   child: const Text('Set Dark theme'),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   // SharedPreferences prefs = await SharedPreferences.getInstance();

//   return runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider<ThemeProvider>(
//           create: (_) => ThemeProvider(),
//         ),
//         Provider<AuthProvider>(
//           create: (context) => AuthProvider(FirebaseAuth.instance),
//         )
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // var themeProvider = Provider.of<ThemeProvider>(context);
//     return Consumer<ThemeProvider>(
//       builder: (context, ThemeProvider themeProvider, child) {
//         return GetMaterialApp(
//           debugShowCheckedModeBanner: false,
//           initialRoute: Onboarding.routeName,
//           //set theme preference from shared prefs
//           theme: themeProvider.isDarkMode ? dark : light,
//           routes: routes,
//         );
//       },
//     );
//   }
// }
// final locator = GetIt.instance;
// void setupLocator() {
//   locator.registerSingleton<NavigationService>(NavigationService());
//   print("registered");
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // setupLocator();
  await Firebase.initializeApp()
      .then((value) => debugPrint('Firebase initialized'));
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
        ChangeNotifierProvider<CountriesProvider>(
          create: (_) => CountriesProvider(),
        ),
        ChangeNotifierProvider<LeaguesProvider>(
          create: (_) => LeaguesProvider(),
        ),
        // ChangeNotifierProvider<DataClass>(
        //   create: (_) => DataClass(),
        // StreamProvider(
        //   create: (context) =>
        //       context.read<AuthProvider>().
        //    initialData: null,: null,
        // ),
        // )
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, ThemeProvider themeProvider, child) {
          return GetMaterialApp(
            key: mtAppKey,
            navigatorKey: NavigationService.navigatorKey,
            title: 'Toppick',
            debugShowCheckedModeBanner: false,
            initialRoute: SignIn.routeName,
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
// class AuthWrapper extends StatelessWidget {
//   //ROUTENAME
//   static const String routeName = '/';
//   const AuthWrapper({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     //auth provider
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     return StreamBuilder<UserModel?>(
//       stream: authProvider.user,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           //PRINT USER DATA
//           debugPrint(snapshot.data.toString());
//           return const Base();
//         } else {
//           return const SplashScreen();
//         }
//       },
//     );
//   }
// }
