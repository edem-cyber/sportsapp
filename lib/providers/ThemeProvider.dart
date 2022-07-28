// import 'package:flutter/material.dart';
// import 'package:sportsapp/helper/storage_manage.dart';
// import 'package:sportsapp/theme.dart';

// class ThemeProvider with ChangeNotifier {
//   final dark = darkTheme();

//   final light = theme();

//   ThemeData? _themeData;
//   ThemeData getTheme() => _themeData!;

//   ThemeProvider() {
//     try {
//       StorageManager.readData('themeMode').then(
//         (value) {
//           debugPrint('value read from storage: $value');
//           var themeMode = value ?? 'light';
//           if (themeMode == 'light') {
//             print('setting light theme');

//             _themeData = light;
//           } else {
//             print('setting dark theme');
//             _themeData = dark;
//           }
//           notifyListeners();
//         },
//       );
//     } catch (e) {
//       debugPrint("$e");
//     }
//   }

//   void setDarkMode() async {
//     _themeData = dark;
//     StorageManager.saveData('themeMode', 'dark');
//     notifyListeners();
//   }

//   void setLightMode() async {
//     _themeData = light;
//     StorageManager.saveData('themeMode', 'light');
//     notifyListeners();
//   }

//   void toggleTheme() {
//     if (_themeData == light) {
//       setDarkMode();
//     } else {
//       setLightMode();
//     }
//   }
// }

// //  final dark = ThemeData(
// //     primarySwatch: Colors.grey,
// //     primaryColor: Colors.black,
// //     brightness: Brightness.dark,
// //     backgroundColor: const Color(0xFF212121),
// //     accentColor: kWhite,
// //     accentIconTheme: IconThemeData(color: Colors.black),
// //     dividerColor: Colors.black12,
// //   );

// //   final light = ThemeData(
// //     primarySwatch: Colors.grey,
// //     primaryColor: kWhite,
// //     brightness: Brightness.light,
// //     backgroundColor: const Color(0xFFE5E5E5),
// //     accentColor: Colors.black,
// //     accentIconTheme: IconThemeData(color: kWhite),
// //     dividerColor: Colors.white54,
// //   );

import 'package:flutter/material.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/services/themeService.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemePreference _themePreference;
  late final ThemeService _service;

  ThemeMode get themeMode => getThemeMode(_themePreference);

  ThemeProvider() {
    _themePreference = ThemePreference.system;
    _service = ThemeService();
    setPersistentTheme();
  }

  setPersistentTheme() async {
    final value = await _service.getTheme(_themePreference,
        defaultValue: ThemePreference.system);
    _themePreference = ThemePreference.values[value];
    notifyListeners();
  }

  ThemeMode getThemeMode(ThemePreference themePreference) {
    switch (themePreference) {
      case ThemePreference.light:
        return ThemeMode.light;
      case ThemePreference.dark:
        return ThemeMode.dark;
      // case ThemePreference.system:
      //   return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void setLight() {
    _themePreference = ThemePreference.light;
    _service.setTheme(ThemePreference.light);
    notifyListeners();
  }

  void setDark() {
    _themePreference = ThemePreference.dark;
    _service.setTheme(ThemePreference.dark);
    notifyListeners();
  }

  void toggleLightOrDark() {
    if (_themePreference == ThemePreference.light) {
      setDark();
    } else {
      setLight();
    }
  }

  void setSystem() {
    _themePreference = ThemePreference.system;
    _service.setTheme(ThemePreference.system);
    notifyListeners();
  }
}
