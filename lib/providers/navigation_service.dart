import 'package:flutter/material.dart';
import 'package:sportsapp/helper/custom_named_route_builder.dart';
import 'package:sportsapp/main.dart';

class NavigationService extends ChangeNotifier {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void removeAndNavigateToRoute(String route) {
    // exit the current page and navigate to another one base on the given route
    navigatorKey.currentState?.pushNamedAndRemoveUntil(route, (route) => false);
  }

  void signOutWithAnimation(String route) {
    navigatorKey.currentState?.pushReplacement(
      CustomNamedPageTransition(MyApp.mtAppKey, route),
    );
  }

  void signInWithAnimation(String route) {
    navigatorKey.currentState?.pushReplacement(
      CustomNamedPageTransition(MyApp.mtAppKey, route),
    );
  }

  void nagivateRoute(String route) {
    // Navigate to other pages
    navigatorKey.currentState?.pushNamed(route);
  }

  void navigateToPage(Widget page) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  void openFullScreenDialog(Widget page) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => page,
        fullscreenDialog: true,
      ),
    );
  }

  void goBack() {
    // Go back to the previous page/screen
    navigatorKey.currentState?.pop();
  }
}
