import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';

class MatchComment extends StatelessWidget {
  final String heading;
  final String text;
  const MatchComment({Key? key, required this.heading, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var shareOptions = [
      // {
      //   'icon': 'assets/icons/heart.svg',
      //   'onPress': () {
      //     debugPrint('heart');
      //   },
      // },
      {
        'icon': 'assets/icons/paper-plane.svg',
        'onPress': () {
          debugPrint('heart');
        },
      },
      {
        'icon': 'assets/icons/share.svg',
        'onPress': () {
          debugPrint('heart');
        },
      },
    ];
    //theme provider
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                heading,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                text,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Row(
          children: [
            SvgPicture.asset(
              shareOptions[0]['icon'] as String,
              color: themeProvider.isDarkMode ? kWhite : kBlack,
              height: 15,
              width: 15,
            ),
            const SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () {
                Share.share('check out my website https://example.com');
              },
              child: SvgPicture.asset(
                shareOptions[1]['icon'] as String,
                color: themeProvider.isDarkMode ? kWhite : kBlack,
                height: 15,
                width: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
// "Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs Guardian Penguins."