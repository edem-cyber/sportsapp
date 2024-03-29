import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';

SnackbarController appNotification({
  required String title,
  required String message,
  required Widget icon,
}) =>
    Get.snackbar(
      backgroundColor:
          Provider.of<ThemeProvider>(Get.context!, listen: false).isDarkMode
              ? kBlack
              : kWhite,
      showProgressIndicator: false,
      shouldIconPulse: true,
      animationDuration: const Duration(milliseconds: 600),
      title,
      message,
      colorText:
          Provider.of<ThemeProvider>(Get.context!, listen: false).isDarkMode
              ? kWhite
              : kBlack,
      mainButton: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Text(
          "Cancel",
          style: TextStyle(
            color: Provider.of<ThemeProvider>(Get.context!, listen: false)
                    .isDarkMode
                ? kWhite
                : kBlack,
          ),
        ),
      ),
      duration: const Duration(milliseconds: 1900),
      icon: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: icon,
        ),
      ),
      snackPosition: SnackPosition.BOTTOM,
    );
