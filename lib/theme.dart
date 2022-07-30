// import 'package:flutter/material.dart';
// import 'package:sportsapp/helper/constants.dart';

// ThemeData theme() {
//   return ThemeData(
//     scaffoldBackgroundColor: kWhite,
//     primarySwatch: Colors.grey,
//     // fontFamily: "Roboto",
//     appBarTheme: appBarTheme(),
//     textTheme: textTheme(),
//     listTileTheme: listTileThemeData(),
//     inputDecorationTheme: inputDecorationTheme(),
//     visualDensity: VisualDensity.adaptivePlatformDensity,
//     // tabBarTheme: TabBarTheme(
//     //   labelColor: kBlack,
//     //   unselectedLabelColor: kBlue,
//     //   indicator: BoxDecoration(
//     //     borderRadius: BorderRadius.circular(50),
//     //     color: kBlack,
//     //   ),
//     // ),
//     // bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//     //   backgroundColor: kWhite,
//     //   selectedItemColor: kBlack,
//     //   unselectedItemColor: kWhite,
//     // ),
//   );
// }


// ThemeData darkTheme() {
//   return ThemeData(
//     scaffoldBackgroundColor: kBlack,
//     brightness: Brightness.dark,
//     primarySwatch: Colors.grey,
//     // bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//     //   backgroundColor: Colors.pink,
//     //   selectedItemColor: kWhite,
//     //   unselectedItemColor: kBlack,
//     // ),
//     // fontFamily: "Roboto",
//     appBarTheme: appBarTheme(),
//     // textTheme: textTheme(),
//     // colorScheme: const ColorScheme.light(
//     //   primary: Color(0xFFDA0000),
//     //   secondary: Color(0xFF1DD110),
//     //   surface: Color(0xFFC8B314),
//     //   background: Color(0xFFE81EBF),
//     //   error: Color(0xFFB00020),
//     //   // brightness: Brightness.dark,
//     // ),
//   );
// }

// InputDecorationTheme inputDecorationTheme() {
//   OutlineInputBorder outlineInputBorder = OutlineInputBorder(
//     borderRadius: BorderRadius.circular(28),
//     borderSide: const BorderSide(color: kTextColor),
//     gapPadding: 10,
//   );
//   return InputDecorationTheme(
//     floatingLabelBehavior: FloatingLabelBehavior.always,
//     contentPadding:
//         const EdgeInsets.only(left: 40, right: 20, top: 20, bottom: 20),
//     enabledBorder: outlineInputBorder,
//     focusedBorder: outlineInputBorder,
//     border: outlineInputBorder,
//   );
// }

// ListTileThemeData listTileThemeData() {
//   return ListTileThemeData(
//       textColor: kTextColor,
//       dense: true,
//       contentPadding: const EdgeInsets.symmetric(
//         vertical: 5,
//         horizontal: 10,
//       ),
//       visualDensity: VisualDensity.adaptivePlatformDensity);
// }

// TextTheme textTheme() {
//   return const TextTheme(
//     bodyText1: TextStyle(color: kTextColor),
//     bodyText2: TextStyle(color: kTextColor),
//   );
// }

// TextTheme darkTextTheme() {
//   return const TextTheme(
//     bodyText1: TextStyle(color: kWhite),
//     bodyText2: TextStyle(color: kWhite),
//   );
// }

// AppBarTheme appBarTheme() {
//   return const AppBarTheme(
//     color: kWhite,
//     elevation: 0,
//     iconTheme: IconThemeData(color: kBlack),
//     // textTheme: TextTheme(
//     //   headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
//     // ),
//   );
// }