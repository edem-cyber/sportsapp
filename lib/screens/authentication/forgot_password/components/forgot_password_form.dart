import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sportsapp/base.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/screens/authentication/sign_in/sign_in.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/widgets/default_button.dart';
import 'package:sportsapp/widgets/form_error.dart';
import 'package:sportsapp/widgets/no_account_text.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final List<String?> errors = [];
  var isLoading = false;
  bool obscureText = true;
  // String? email;
  // String? password;
  // SignInBody? signInBody;
  bool? remember = false;

  final TextEditingController _emailController =
      TextEditingController(text: "edem.agbakpe@icloud.com");

  final _formKey = GlobalKey<FormState>();
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  // late NavigationService _navigationService;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context);
    // _auth = Provider.of<AuthenticationProvider>(context);
    // _navigationService = GetIt.instance.get<NavigationService>();
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      //border side none
      borderSide: const BorderSide(color: Colors.amber, width: 0),

      gapPadding: 10,
    );

    InputDecoration inputDecoration = InputDecoration(
      fillColor: Colors.grey,
      // theme: inputDecorationTheme(),
      contentPadding:
          const EdgeInsets.only(left: 40, right: 20, top: 20, bottom: 20),
      focusedBorder: outlineInputBorder,
      border: outlineInputBorder,
      labelText: "Password",
      hintText: "Enter your password",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    );

    InputDecoration emailInputDecoration = InputDecoration(
      contentPadding:
          const EdgeInsets.only(left: 40, right: 20, top: 20, bottom: 20),
      focusedBorder: outlineInputBorder,
      border: outlineInputBorder,
      labelText: "Email",
      hintText: "Enter your email",
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: const Icon(
        Icons.mail,
      ),
    );

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            decoration: BoxDecoration(
              color: kGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(32),
            ),
            child: buildEmailFormField(),
          ),
          const SizedBox(height: 18),
          FormError(errors: errors),
          const SizedBox(height: 10),
          DefaultButton(
            textColor: kWhite,
            color: kBlue,
            icon: const Icon(Icons.arrow_forward, color: kWhite),
            text: "Continue",
            press: () async {
              // Navigator.pushNamed(context, Base.routeName);
              // _navigationService.nagivateRoute(Base.routeName);
            },
          ),
          const SizedBox(height: 10),
          NoAccountText(
            text: "I have an account",
            press: () {
              Navigator.of(context).pushNamed(SignIn.routeName);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
