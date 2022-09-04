import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/screens/privacy_policy/privacy_policy.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var navigationService = Provider.of<NavigationService>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Night Mode",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Transform.scale(
                  scale: 1,
                  child: CupertinoSwitch(
                    activeColor: Colors.green,
                    value: themeProvider.isDarkMode,
                    onChanged: (bool value) {
                      themeProvider.toggleLightOrDark();
                    },
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Push Notifications",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Transform.scale(
                  scale: 1,
                  child: CupertinoSwitch(
                    activeColor: Colors.green,
                    value: !themeProvider.isDarkMode,
                    onChanged: (bool value) {
                      themeProvider.toggleLightOrDark();
                    },
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              navigationService.nagivateRoute(PrivacyPolicy.routeName);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Security alerts",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "Push, email, in app, sms",
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              navigationService.nagivateRoute(PrivacyPolicy.routeName);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Privacy Policy",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
