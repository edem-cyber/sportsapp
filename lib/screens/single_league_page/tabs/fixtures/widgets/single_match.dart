import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';

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
