import 'package:flutter/material.dart';

const kBlue = Color(0xFF416DFF);
Color kLightBlue = kBlue.withOpacity(0.5);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF3EFF48), Color(0xEEEEEEEE)],
);
const kTertiaryColor = Color(0xffF5A000);
const kBlack = Color(0xFF252525);
const kTextColor = Color(0xFF444444);
const kTextLightColor = Color(0xFF9E9E9E);
const kGrey = Color(0xFF757575);
const kWhite = Color(0xFFFFFFFF);
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
    bodyText1: TextStyle(color: kBlack),
    bodyText2: TextStyle(color: kBlack),
  );
}

TextTheme darkTextTheme() {
  return const TextTheme(
    bodyText1: TextStyle(color: kWhite),
    bodyText2: TextStyle(color: kWhite),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    color: kWhite,
    elevation: 0,
    iconTheme: IconThemeData(color: kBlack),
    // textTheme: TextTheme(
    //   headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
    // ),
  );
}

AppBarTheme darkAppBarTheme() {
  return const AppBarTheme(
    color: kBlack,
    elevation: 0,
    iconTheme: IconThemeData(color: kWhite),
    // textTheme: TextTheme(
    //   headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
    // ),
  );
}
