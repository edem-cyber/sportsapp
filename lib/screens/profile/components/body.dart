import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/screens/profile/components/profile_menu.dart';
import 'package:sportsapp/screens/profile/components/profile_pic.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView(
        children: [
          ProfilePic(
            icon: AppImage.logoMainImage,
            text: "Edem Agbakpe",
            subText: "+234 803 567 809",
            press: () {},
          ),
          // const SizedBox(height: 20),
          //switch list tile
          const SizedBox(height: 20),

          ProfileMenu(
            text: "Dark mode",
            icon: Icons.brightness_3,
            child: CupertinoSwitch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                if (value == true) {
                  themeProvider.setDark();
                } else {
                  themeProvider.setLight();
                }
              },
            ),
            // press: () {
            // Navigator.pushNamed(context, SignIn.routeName);
            // },
          ),
          ProfileMenu(
            text: "Dark mode",
            icon: Icons.brightness_3,
            child: CupertinoSwitch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                if (value == true) {
                  themeProvider.setDark();
                } else {
                  themeProvider.setLight();
                }
              },
            ),
            // press: () {
            // Navigator.pushNamed(context, SignIn.routeName);
            // },
          ),
          // ProfileMenu(
          //   text: "Address Book",
          //   icon: Icons.favorite,
          //   press: () {
          //     // Navigator.pushNamed(context, SignIn.routeName);
          //   },
          // ),
          // ProfileMenu(
          //   text: "Settings",
          //   icon: Icons.favorite,
          //   press: () {
          //     // Navigator.pushNamed(context, SignIn.routeName);
          //   },
          // ),
          // ProfileMenu(
          //   text: "Log Out",
          //   icon: Icons.favorite,
          //   press: () {
          //     // Navigator.pushNamed(context, SignIn.routeName);
          //   },
          // ),
        ],
      ),
    );
  }
}
