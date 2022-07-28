import 'package:flutter/material.dart';
import 'package:sportsapp/screens/authentication/forgot_password/components/forgot_password_form.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30, top: 60),
                child: Column(
                  children: [
                    Text(
                      "Forgot Password",
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Input your email to reset your password",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const ForgotPasswordForm(),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
