// import 'package:flutter/material.dart';
// import 'package:saharago_b2b/constants.dart';

// class SearchFilterButton extends StatelessWidget {
//   //declare icon
//   final IconData? icon;
//   final String? text;
//   const SearchFilterButton({Key? key, this.icon, this.text}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ElevatedButton.icon(
//           style: ElevatedButton.styleFrom(
//             padding: EdgeInsets.all(10),
//             elevation: 0,
//             primary: kButtonColor,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(5),
//             ),
//           ),
//           onPressed: () {},
//           icon: Text(text!, style: TextStyle(color: kBlack)),
//           label: Icon(icon, color: kBlack)),
//     );
//   }
// }