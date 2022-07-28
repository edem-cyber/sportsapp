import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportsapp/helper/constants.dart';

class ThemeService {
  Future<bool> setTheme(ThemePreference themePreference) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setInt(themeKey, themePreference.index);
  }

  Future<int> getTheme(ThemePreference themePreference,
      {required ThemePreference defaultValue}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(themeKey) ??
        ThemePreference.values.length - 1;
  }
}
