import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/models/Post.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/screens/home/widgets/article_view.dart';
import 'package:share_plus/share_plus.dart';

class NewsTile extends StatelessWidget {
  // final String currentUid;
  // final String title, desc, content, posturl;
  // final String? imgUrl;
  final Article article;
  final Function()? onTap;
  bool isLiked;
  // late bool isLiked;

  NewsTile({
    Key? key,
    // required this.imgUrl,
    // required this.desc,
    // required this.title,
    // required this.content,
    // required this.posturl,
    this.onTap,
    required this.isLiked,
    required this.article,
    // required this.currentUid
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // int getLikeCount(likes) {
    //   // if no likes, return 0
    //   if (likes == null) {
    //     return 0;
    //   }
    //   int count = 0;
    //   // if the key is explicitly set to true, add a like
    //   likes.values.forEach((val) {
    //     if (val == true) {
    //       count += 1;
    //     }
    //   });
    //   return count;
    // }

    var authProvider = Provider.of<AuthProvider>(context, listen: false);
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
    var themeprovider = Provider.of<ThemeProvider>(context, listen: false);
    var _navigationService =
        Provider.of<NavigationService>(context, listen: false);
    return GestureDetector(
      onTap: () {
        debugPrint("IMAGE URL IS: $article.urlToImage");
        _navigationService.navigateToPage(
          ArticleView(
            postUrl: article.articleUrl!,
            title: article.title!,
            desc: article.description!,
            content: article.content!,
            imgUrl: article.urlToImage ?? "",
          ),
        );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     fullscreenDialog: true,
        //     builder: (context) => ArticleView(
        //       postUrl: posturl,
        //       title: title,
        //       desc: desc,
        //       content: content,
        //       imgUrl: imgUrl ?? "",
        //     ),
        //   ),
        // );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CachedNetworkImage(
              useOldImageOnUrlChange: true,
              imageBuilder: (context, imageProvider) => AspectRatio(
                aspectRatio: 2,
                child: Container(
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
              imageUrl: article.urlToImage!.startsWith("//")
                  ? "https:$article.urlToImage"
                  : article.urlToImage ?? "",
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
              height: 15,
            ),
            article.title!.isNotEmpty
                ? Text(
                    article.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline6!,
                  )
                : Shimmer.fromColors(
                    baseColor: kTextLightColor,
                    highlightColor: const Color(0xFFFFFFFF),
                    child: Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 4,
            ),
            article.description!.isNotEmpty || article.description! != null
                ? Text(
                    article.description!,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                : Shimmer.fromColors(
                    baseColor: kTextLightColor,
                    highlightColor: const Color(0xFFFFFFFF),
                    child: Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                FutureBuilder<Object>(
                    initialData: false,
                    future: authProvider.isPostInLikedArray(article),
                    builder: (context, snapshot) {
                      return LikeButton(
                        onTap: ((isLiked) async {
                          // isLiked = !isLiked;
                          authProvider.likePost(article);
                          // authProvider.isPostLiked(article);
                          // var isPostLikedInDb =
                          //     await authProvider.isPostLiked(article);
                          // isLiked = isPostLikedInDb;
                          // debugPrint("IS LIKED: $isLiked");
                          // authProvider.getLikedPostsArray();
                        }),
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
                          return SvgPicture.asset(
                            'assets/icons/heart.svg',
                            color: isLiked
                                ? kWarning
                                : themeprovider.isDarkMode
                                    ? kWhite
                                    : kBlack,
                            height: 15,
                            width: 15,
                          );
                        },
                        // likeCount: 665,
                      );
                    }),

                // FutureBuilder(
                //   future: authProvider.isPostInLikedArray(article),
                //   initialData: false,
                //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                //     return LikeButton(
                //       onTap: ((isLiked) async {
                //         isLiked = !isLiked;
                //         await authProvider.likePost(article);
                //         return isLiked;
                //       }),
                //       size: 15,
                //       circleColor: const CircleColor(
                //         start: kBlue,
                //         end: kBlue,
                //       ),
                //       bubblesColor: const BubblesColor(
                //         dotPrimaryColor: kBlue,
                //         dotSecondaryColor: kBlue,
                //       ),
                //       likeBuilder: (bool isLiked) {
                //         return SvgPicture.asset(
                //           'assets/icons/heart.svg',
                //           color: isLiked
                //               ? kWarning
                //               : themeprovider.isDarkMode
                //                   ? kWhite
                //                   : kBlack,
                //           height: 15,
                //           width: 15,
                //         );
                //       },
                //     );
                //   },
                // ),
                const SizedBox(
                  width: 15,
                ),
                SvgPicture.asset(
                  shareOptions[0]['icon'] as String,
                  color: themeprovider.isDarkMode ? kWhite : kBlack,
                  height: 15,
                  width: 15,
                ),
                const SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Share.share(article.articleUrl!);
                  },
                  child: SvgPicture.asset(
                    shareOptions[1]['icon'] as String,
                    color: themeprovider.isDarkMode ? kWhite : kBlack,
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
            )
          ],
        ),
      ),
    );
  }
}

// Icon(
//                         Icons.home,
//                         color: isLiked
//                             ? kWarning
//                             : themeprovider.isDarkMode
//                                 ? kWhite
//                                 : kBlue,
//                         size: 15,
//                       );