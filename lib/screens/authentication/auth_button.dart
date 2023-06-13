import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    Key? key,
    this.text,
    this.press,
    this.color = kBlue,
    this.textColor = kWhite,
    this.icon = const SizedBox(),
  }) : super(key: key);
  final String? text;
  final Widget icon;
  final Color? color;
  final Color? textColor;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: kWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: color,
        ),
        onPressed: press,
        label: icon,
        icon: Consumer<AuthProvider>(
          builder: (context, provider, child) {
            return provider.isLoading
                ? const CupertinoActivityIndicator(
                    // valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                    color: kWhite,
                  )
                : Text(
                    text!,
                    style: TextStyle(
                      fontSize: 10,
                      color: textColor,
                    ),
                  );
          },
        ),
      ),
    );
  }
}
