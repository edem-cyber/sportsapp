import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';

class SingleMatch extends StatelessWidget {
  final String? homeTeam;
  final String? awayTeam;
  final int? matchday;
  final String? utcDate;
  final String? homeLogo;
  final String? awayLogo;
  const SingleMatch({
    Key? key,
    this.homeTeam,
    this.awayTeam,
    this.matchday,
    this.utcDate,
    this.homeLogo,
    this.awayLogo,
  }) : super(key: key);

  String parseMyDate(String date) {
    //parse date from 2022-12-21T19:45:00Z to 19:45
    var mydate = DateTime.parse(date);

    var formattedDate = DateFormat('HH:mm').format(mydate);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    var defImage = "https://pic.onlinewebfonts.com/svg/img_264157.png";
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //match day text
          // Text(
          //   "MD $matchday",
          //   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          //         color: kWhite,
          //       ),
          // ),
          Text(
            homeTeam ?? "",
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
          homeLogo == null
              ? Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.error,
                      color: kBlack,
                    ),
                  ),
                )
              : homeLogo.toString().contains('.svg') == true
                  ? SvgPicture.network(
                      homeLogo ?? defImage,
                      width: 50,
                    )
                  : CachedNetworkImage(
                      imageUrl: homeLogo ?? defImage,
                      width: 50,
                    ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 60,
            alignment: Alignment.center,
            child: Text(
              // regex to remove time from date
              //
              parseMyDate(utcDate ?? ""),
              style: themeProvider.isDarkMode
                  ? Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: kWhite,
                      )
                  : Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: kBlack,
                      ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          awayLogo == null
              ? Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.error,
                      color: kBlack,
                    ),
                  ),
                )
              : awayLogo.toString().contains('.svg') == true
                  ? SvgPicture.network(
                      awayLogo ?? defImage,
                      width: 50,
                    )
                  : CachedNetworkImage(
                      imageUrl: awayLogo ?? defImage,
                      width: 50,
                    ),
          const SizedBox(
            width: 10,
          ),
          Text(
            awayTeam ?? "",
            style: themeProvider.isDarkMode
                ? Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: kWhite,
                    )
                : Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: kBlack,
                    ),
          ),
        ],
      ),
    );
  }
}
