import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sportsapp/helper/constants.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    this.text,
    this.image,
    this.heading,
  }) : super(key: key);
  final String? text, image, heading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Spacer(
            flex: 4,
          ),
          // Text(
          //   "SAHARAGO",
          //   style: TextStyle(
          //     fontSize: getProportionateScreenWidth(36),
          //     color: kPrimaryColor,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),

          Text(
            heading!,
            style: const TextStyle(
              fontSize: (36),
              color: kWhite,
              fontWeight: FontWeight.bold,
            ),
            // textAlign: TextAlign.center,
          ),
          // const Spacer(flex: 2),
          const SizedBox(
            height: 20,
          ),
          Text(
            text!,
            style: const TextStyle(
                fontWeight: FontWeight.w200, fontSize: 15, color: kWhite),
            // textAlign: TextAlign.center,
          ),
          // Image.asset(
          //   image!,
          //   height: getProportionateScreenHeight(265),
          //   width: getProportionateScreenWidth(235),
          // ),
          // const Spacer(flex: 2),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
