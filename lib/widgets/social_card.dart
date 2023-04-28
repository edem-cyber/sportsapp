import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sportsapp/helper/constants.dart';

class SocialCard extends StatelessWidget {
  const SocialCard({
    Key? key,
    this.text,
    this.press,
    this.color = kBlue,
    this.textColor = kBlack,
    this.icon = const SizedBox(),
  }) : super(key: key);

  final color;
  final icon;
  final VoidCallback? press;
  final String? text;
  final textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: ElevatedButton.icon(
          style: OutlinedButton.styleFrom(
            // primary: color,
            foregroundColor: kBlack,
            side: BorderSide(
              color: color,
              width: 1,
            ),

            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            backgroundColor: const Color(0xFFF8FAFF),
            // border color
          ),
          onPressed: press,
          label: Text(
            text ?? "",
            style: TextStyle(
              fontSize: 13,
              color: textColor,
            ),
          ),
          icon: SvgPicture.asset(
            icon,
            width: 20,
            height: 20,
          ),
        ));
  }
}
