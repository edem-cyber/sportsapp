import 'package:flutter/material.dart';
import 'package:sportsapp/helper/constants.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.text,
    this.press,
    this.color = kBlue,
    this.textColor = kWhite,
    this.icon = const SizedBox.shrink(),
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
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: color,
        ),
        onPressed: press,
        label: icon,
        icon:
            // Provider.of<AuthProvider>(context).isLoading()
            //     ? const CupertinoActivityIndicator(
            //         // valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
            //         color: kWhite,
            //       )
            //     :
            Text(
          text!,
          style: TextStyle(
            fontSize: 13,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
