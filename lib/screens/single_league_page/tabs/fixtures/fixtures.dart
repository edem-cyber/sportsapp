import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/screens/match_news_page/match_news_page.dart';
import 'package:sportsapp/screens/single_league_page/tabs/fixtures/widgets/match_day.dart';

class FixturesTab extends StatelessWidget {
  final String code;
  const FixturesTab({Key? key, required this.code}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      decoration: const BoxDecoration(

          // gradient: LinearGradient(
          //   colors: [
          //     kWhite,
          //     kWhite,
          //   ],
          //   begin: FractionalOffset(0.0, 0.0),
          //   end: FractionalOffset(0.0, 1.0),
          //   stops: [0.0, 1.0],
          //   tileMode: TileMode.clamp,
          // ),
          ),
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            "Match Day 13",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const MatchDay(),
          const MatchDay(),
          const MatchDay(),
          const MatchDay()
        ],
      ),
    );
  }
}

class SingleMatch extends StatelessWidget {
  const SingleMatch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "MUN",
          style: themeProvider.isDarkMode
              ? Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: kWhite,
                  )
              : Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: kBlack,
                  ),
        ),
        const SizedBox(
          width: 10,
        ),
        CachedNetworkImage(
          imageUrl: "https://img.icons8.com/color/48/000000/chelsea-fc.png",
          width: 30,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          "10:00",
          style: themeProvider.isDarkMode
              ? Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: kWhite,
                  )
              : Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: kBlack,
                  ),
        ),
        const SizedBox(
          width: 10,
        ),
        CachedNetworkImage(
          imageUrl:
              "https://img.icons8.com/color/48/000000/manchester-united-fc.png",
          width: 30,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          "CHE",
          style: themeProvider.isDarkMode
              ? Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: kWhite,
                  )
              : Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: kBlack,
                  ),
        ),
      ],
    );
  }
}
