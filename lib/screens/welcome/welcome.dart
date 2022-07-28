import 'package:flutter/material.dart';
import 'package:sportsapp/base.dart';
import 'package:sportsapp/screens/authentication/sign_in/sign_in.dart';
import 'package:sportsapp/screens/authentication/sign_up/sign_up.dart';
import 'package:sportsapp/widgets/default_button.dart';
import 'package:sportsapp/widgets/no_account_text.dart';

class Welcome extends StatelessWidget {
  static String routeName = "/welcome";
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Spacer(
              flex: 3,
            ),
            //sportsapp logo
            Image.asset(
              "assets/icons/TOPPICK.png",
              fit: BoxFit.contain,
              height: 50,
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              " Hey Welcome",
              // style: Theme.of(context).textTheme.bodyText1,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                " Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs",
                // style: Theme.of(context).textTheme.bodyText1,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            DefaultButton(
              text: "Get Started",
              press: () {
                Navigator.of(context).pushNamed(SignUp.routeName);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            NoAccountText(
              text: "Already have an account?",
              press: () {
                Navigator.of(context).pushNamed(SignIn.routeName);
              },
            ),
            const Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    ));
  }
}
