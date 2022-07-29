import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

class CustomNamedPageTransition extends PageRouteBuilder {
  CustomNamedPageTransition(
    GlobalKey materialAppKey,
    String routeName, {
    Object? arguments,
  }) : super(
          settings: RouteSettings(
            arguments: arguments,
            name: routeName,
          ),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            assert(materialAppKey.currentWidget != null);
            var mtapp = materialAppKey.currentWidget as GetMaterialApp;
            // assert(mtapp is MaterialApp);

            var routes = mtapp.routes;
            assert(routes!.containsKey(routeName));
            return routes![routeName]!(context);
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>

              //fade and scale transition
              FadeTransition(
            opacity: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
            ),
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
              ),
              child: child,
            ),
          ),
          transitionDuration: const Duration(milliseconds: 400),
        );
}
