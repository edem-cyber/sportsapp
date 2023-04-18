import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sportsapp/helper/constants.dart';

class NoInternetPage extends StatelessWidget {
  static const routeName = "no_internet";

  const NoInternetPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AvatarGlow(
              glowColor: const Color(0xFFFFD7DD),
              duration: const Duration(milliseconds: 1500),
              showTwoGlows: true,
              curve: Curves.fastLinearToSlowEaseIn,
              endRadius: 60.0,
              child: Material(
                shape: const CircleBorder(),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.warning_amber)
                ),
              ),
            ),
            // const SizedBox(height: 20),
            Text(
              'Too many attempts \n made to authenticate',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: kBlack, fontSize: 31, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Try to sign in again in 23 hours 12 minutes',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: kGrey,
                    fontSize: 18,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
