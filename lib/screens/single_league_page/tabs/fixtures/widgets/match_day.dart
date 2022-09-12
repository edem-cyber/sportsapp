// import 'package:flutter/material.dart';

// class MatchDay extends StatelessWidget {
//   final int numberOfMatches;
//   const MatchDay({Key? key, required this.numberOfMatches})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const Text("Sun 7 Aug 2022"),
//         const SizedBox(
//           height: 10,
//         ),
//         ListView.builder(
//           itemCount: numberOfMatches,
//           itemBuilder: (BuildContext context, int index) {
//             return Row(
//               children: [
//                 Text(
//                   "MUN",
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//                 Text("MUN"),
//               ],
//             );
//           },
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//       ],
//     );
//   }
// }
