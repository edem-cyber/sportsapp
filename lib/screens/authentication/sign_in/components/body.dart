import 'package:flutter/material.dart';
import 'sign_in_form.dart';

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
                child: Text(
                  "Welcome Back",
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
              const SignForm(),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}