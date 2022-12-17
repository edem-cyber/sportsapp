import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/screens/single_league_page/tabs/fixtures/fixtures.dart';

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



class MatchDay extends StatelessWidget {
  const MatchDay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //theme provider
    final themeProvider = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, MatchNewsPage.routeName);
      },
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            "Sun 7 Aug 2022",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          const SingleMatch(),
          const SizedBox(
            height: 20,
          ),
          const SingleMatch(),
          const SizedBox(
            height: 20,
          ),
          const SingleMatch(),
        ],
      ),
    );
  }
}