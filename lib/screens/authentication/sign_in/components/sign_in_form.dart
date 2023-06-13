import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/screens/authentication/auth_button.dart';
import 'package:sportsapp/screens/authentication/forgot_password/forgot_password.dart';
import 'package:sportsapp/screens/authentication/sign_up/sign_up.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/widgets/form_error.dart';
import 'package:sportsapp/widgets/no_account_text.dart';
import 'package:sportsapp/widgets/social_card.dart';

class SignForm extends StatefulWidget {
  const SignForm({Key? key}) : super(key: key);

  @override
  State<SignForm> createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final List<String?> errors = [];
  bool obscureText = true;
  // String? email;
  // String? password;
  // SignInBody? signInBody;
  bool? remember = false;

  final TextEditingController _emailController =
      TextEditingController(text: "edem.agbakpe@icloud.com");

  final _formKey = GlobalKey<FormState>();
  late NavigationService _navigationService;
  final TextEditingController _passwordController =
      TextEditingController(text: "1234567");

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: obscureText,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 7) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "Enter Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "Enter Email",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    // _navigationService = GetIt.instance.get<NavigationService>();
    _navigationService = Provider.of<NavigationService>(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            decoration: BoxDecoration(
              color: kGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(32),
            ),
            child: buildEmailFormField(),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            decoration: BoxDecoration(
              color: kGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(32),
            ),
            child: buildPasswordFormField(),
          ),
          FormError(errors: errors),
          const SizedBox(height: 18),
          FormError(errors: errors),
          const SizedBox(height: 10),
          AuthButton(
            textColor: kWhite,
            color: kBlue,
            text: "Sign In",
            press: () {
              try {
                if (_formKey.currentState!.validate()) {
                  authProvider.signIn(
                    _emailController.text,
                    _passwordController.text,
                  );
                }
              } catch (e) {
                debugPrint("Auth Button Error: $e");
              }
            },
          ),
          const SizedBox(height: 10),
          NoAccountText(
            text: "I don’t have an account",
            press: () {
              // Navigator.of(context).pushNamed(SignUp.routeName);
              _navigationService.removeAndNavigateToRoute(SignUp.routeName);
            },
          ),
          NoAccountText(
            text: "Forgot password ?",
            press: () {
              // Navigator.of(context).pushNamed(ForgotPassword.routeName);
              _navigationService.nagivateRoute(ForgotPassword.routeName);
            },
          ),
          const SizedBox(height: 10),
          Row(children: <Widget>[
            const Expanded(child: Divider()),
            Container(
              width: 30,
              alignment: Alignment.center,
              child: Text(
                "or",
                style: TextStyle(
                  color: kGrey.withOpacity(0.4),
                  fontSize: 16,
                ),
              ),
            ),
            const Expanded(
              child: Divider(),
            ),
          ]),
          const SizedBox(height: 18),
          SocialCard(
            text: "Continue with Google",
            icon: "assets/icons/google.svg",
            press: () async {
              authProvider.signInWithGoogle();
            },
          ),
          SocialCard(
            text: "Continue Anonymously",
            // icon: "assets/icons/fb.svg",
            press: () {
              authProvider.signInAnonymously();
            },
          ),
          SocialCard(
            text: "Continue with Apple",
            icon: "assets/icons/apple.svg",
            press: () {
              authProvider.appleSign();
            },
          ),
        ],
      ),
    );
  }
}
