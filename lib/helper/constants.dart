import 'package:flutter/material.dart';

const kBlue = Color(0xFF305FFC);
const kLightBlue = Color(0xFF89A5FF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF3EFF48), Color(0xEEEEEEEE)],
);
const kTertiaryColor = Color(0xffF5A000);
const kBlack = Color(0xFF252525);
const kBlack500 = Color(0xFF1F1F1F);
const kTextColor = Color(0xFF444444);
const kTextLightColor = Color(0xFFB4B4B4);
const kGrey = Color(0xFF757575);
const kWhite = Color(0xFFFFFFFF);
const kDeepPurple = Color(0xFF2B002F);
const kWarning = Color(0xFFFF4646);
const kAnimationDuration = Duration(milliseconds: 200);
const headingStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: kBlack,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kPassMatchError = "Passwords must match";
const String kMatchPassError = "Passwords don't match";
const String kNameNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 12),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(13),
    borderSide: const BorderSide(color: kTextColor),
  );
}

enum ThemePreference {
  light,
  dark,
  system,
}

ThemeData light = ThemeData(
  primaryColor: kBlue,
  scaffoldBackgroundColor: kWhite,
  appBarTheme: appBarTheme(),
  textTheme: textTheme(),
  colorScheme: const ColorScheme.light()
      .copyWith(
        secondary: kWhite,
        brightness: Brightness.light,
      )
      .copyWith(secondary: kBlue),
);

ThemeData dark = ThemeData(
  primaryColor: kWhite,
  scaffoldBackgroundColor: kBlack,
  brightness: Brightness.dark,
  textTheme: darkTextTheme(),
  primarySwatch: Colors.grey,
  appBarTheme: darkAppBarTheme(),
);

const String themeKey = 'theme_key';

TextTheme textTheme() {
  return const TextTheme(
    bodyLarge: TextStyle(color: kBlack),
    bodyMedium: TextStyle(color: kBlack),
  );
}

TextTheme darkTextTheme() {
  return const TextTheme(
    bodyLarge: TextStyle(color: kWhite),
    bodyMedium: TextStyle(color: kWhite),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    color: kWhite,
    elevation: 1,
    iconTheme: const IconThemeData(color: kBlack),
    toolbarTextStyle: const TextTheme(
      titleLarge: TextStyle(color: kBlack, fontSize: 18),
    ).bodyMedium,
    titleTextStyle: const TextTheme(
      titleLarge: TextStyle(color: kBlack, fontSize: 18),
    ).titleLarge,
  );
}

AppBarTheme darkAppBarTheme() {
  return AppBarTheme(
    color: kBlack,
    elevation: 1,
    iconTheme: const IconThemeData(color: kWhite),
    toolbarTextStyle: const TextTheme(
      titleLarge: TextStyle(color: kWhite, fontSize: 18),
    ).bodyMedium,
    titleTextStyle: const TextTheme(
      titleLarge: TextStyle(color: kWhite, fontSize: 18),
    ).titleLarge,
  );
}

//list of league codes for the api
List<String> leagueCodes = [
  'PL',
  'BL1',
  'SA',
  // 'PD',
  // 'FL1',
  // 'DED',
  'CL',
  'CLI',
  'WC',
  // 'EC',
  'EL1',
  'ELC',
  'PD',
  'SD',
  'CDR',
  'PPL',
  'DED',
  'EC',
  'BSA',
  'BSB',
];

// var token = "99cb458cbb81483e9e2e3621e9ae23f4";
//   // var token = "be1eb21948af4c8fa080ee214406c4be";
