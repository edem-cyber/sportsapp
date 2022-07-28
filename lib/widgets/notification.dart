import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportsapp/helper/constants.dart';

SnackbarController appNotification({
  required String title,
  required String message,
  required Widget icon,
}) =>
    Get.snackbar(
      showProgressIndicator: false,
      shouldIconPulse: false,
      animationDuration: const Duration(milliseconds: 600),
      title,
      message,
      colorText: kWhite,
      mainButton: TextButton(
        onPressed: () {
          Get.back();
        },
        child: const Text(
          "Cancel",
          // style: TextStyle(color: kTertiaryColor),
        ),
      ),
      duration: const Duration(milliseconds: 1300),
      // messageText: Text('Item removed'),
      // backgroundColor: kBlack,
      icon: AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: icon,
        ),
      ),
      snackPosition: SnackPosition.BOTTOM,
    );
