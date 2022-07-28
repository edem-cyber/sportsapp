import 'package:flutter/material.dart';
import 'package:sportsapp/helper/constants.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
    required this.text,
    required this.subText,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon, subText;
  final VoidCallback? press;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          // primary: kBlack,
          // padding: EdgeInsets.symmetric(),
          // shape: RoundedRectangleBorder(
          //     // borderRadius: BorderRadius.circular(15),
          //     ),
          // backgroundColor: Color(0xFFF5F6F9),
          ),
      onPressed: press,
      child: Row(
        children: [
          const SizedBox(
            width: 35,
            height: 35,
            child: Icon(Icons.person),
          ),
          // SizedBox(
          //     // width: getProportionateScreenWidth(30),
          //     ),
          Column(
            children: [
              Text(text),
              Text(
                subText,
              ),
            ],
          )
          // Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
