// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class NoConnection extends StatelessWidget {
//   final String image;
//   final String? title;
//   final String? subtitle;
//   const NoConnection(
//       {Key? key,
//       required this.image,
//       required this.title,
//       required this.subtitle})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SvgPicture.asset(image),
//         Container(
//           padding: EdgeInsets.only(
//               top: 30,
//               bottom: 10,
//               left: getProportionateScreenWidth(50),
//               right: getProportionateScreenWidth(50)),
//           child: H2(text: title!)
//         ),
//         Text(
//           subtitle!,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//               color: kTextLightColor,
//               fontSize: 15,
//               fontWeight: FontWeight.w600),
//         ),
//       ],
//     );
//   }
// }
