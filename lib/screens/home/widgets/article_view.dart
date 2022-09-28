import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatelessWidget {
  // In the constructor, require a Todo.
  const ArticleView(
      {super.key,
      required this.title,
      required this.postUrl,
      required this.content,
      required this.desc,
      required this.imgUrl});

  // Declare a field that holds the Todo.
  // final Post todo;
  final String title;
  final String postUrl;
  final String content;
  final String desc;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    var shareOptions = [
      // {
      //   'icon': 'assets/icons/heart.svg',
      //   'onPress': () {
      //     print('heart');
      //   },
      // },
      {
        'icon': 'assets/icons/paper-plane.svg',
        'onPress': () {
          print('heart');
        },
      },
      {
        'icon': 'assets/icons/share.svg',
        'onPress': () {
          print('heart');
        },
      },
    ];
    // Use the Todo to create the UI.
    var themeProvider = Provider.of<ThemeProvider>(context);
    var navigationService = Provider.of<NavigationService>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("News"),
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back_rounded),
          onTap: () {
            navigationService.goBack();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          children: [
            CachedNetworkImage(
              imageBuilder: (context, imageProvider) => AspectRatio(
                aspectRatio: 2,
                child: Container(
                  // height: 150,
                  // width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const AspectRatio(
                aspectRatio: 2,
                child: Center(
                  child: Icon(Icons.error),
                ),
              ),
              imageUrl: imgUrl.startsWith("//") ? "https:$imgUrl" : imgUrl,
              placeholder: (context, url) => AspectRatio(
                aspectRatio: 2,
                child: Shimmer.fromColors(
                  baseColor: kTextLightColor,
                  highlightColor: kWhite,
                  child: Container(
                    // height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(desc),
            // ElevatedButton(
            //     onPressed: () {
            //       print(desc);
            //     },
            //     child: Text("hit me")),
            const SizedBox(
              height: 20,
            ),
            //webview of the article
            // WebView(
            //   initialUrl: postUrl,
            //   javascriptMode: JavascriptMode.unrestricted,
            // ),
            Row(
              children: [
                LikeButton(
                  // onTap: ((isLiked) async {
                  //   return !isLiked;
                  // }),
                  size: 15,
                  circleColor: const CircleColor(
                    start: kBlue,
                    end: kBlue,
                  ),
                  bubblesColor: const BubblesColor(
                    dotPrimaryColor: kBlue,
                    dotSecondaryColor: kBlue,
                  ),
                  likeBuilder: (bool isLiked) {
                    // isLiked = isLiked;
                    // isLiked = isLiked;
                    return SvgPicture.asset(
                      'assets/icons/heart.svg',
                      color: isLiked
                          ? kWarning
                          : themeProvider.isDarkMode
                              ? kWhite
                              : kBlack,
                      height: 15,
                      width: 15,
                    );
                  },
                  // likeCount: 665,
                ),
                const SizedBox(
                  width: 15,
                ),
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
                    Share.share(postUrl);
                  },
                  child: SvgPicture.asset(
                    shareOptions[1]['icon'] as String,
                    color: themeProvider.isDarkMode ? kWhite : kBlack,
                    height: 15,
                    width: 15,
                  ),
                ),

                const SizedBox(
                  width: 15,
                ),
                // Container(
                //   // margin: const EdgeInsets.only(left: 5),
                //   child: SvgPicture.asset(shareOptions[i]['icon'] as String,
                //       color: themeprovider.isDarkMode ? kWhite : kBlue,
                //       height: 25,
                //       width: 25,
                //       fit: BoxFit.contain),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
