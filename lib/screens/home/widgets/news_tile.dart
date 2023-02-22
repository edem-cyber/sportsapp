import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/models/Post.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/screens/home/widgets/article_view.dart';
import 'package:share_plus/share_plus.dart';

class NewsTile extends StatefulWidget {
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
  }) : super(key: key);

  final Function()? onTap;
  // final String currentUid;
  // final String title, desc, content, posturl;
  // final String? imgUrl;
  final Article article;

  late bool isLiked;

  // bool isLiked;

  @override
  State<NewsTile> createState() => _NewsTileState();
}

class _NewsTileState extends State<NewsTile> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var getIsLiked = authProvider.isLiked(widget.article);
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

    // getLikesInFirebase() {

    // }

    var shareOptions = [
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
        // debugPrint("IMAGE URL IS: ${widget.article.urlToImage}");
        _navigationService.navigateToPage(
          ArticleView(
            postUrl: widget.article.articleUrl!,
            title: widget.article.title!,
            desc: widget.article.description!,
            content: widget.article.content!,
            imgUrl: widget.article.urlToImage ?? "",
          ),
        );
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
              imageUrl: widget.article.urlToImage!.startsWith("//")
                  ? "https:${widget.article.urlToImage}"
                  : widget.article.urlToImage ?? "",
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
            widget.article.title!.isNotEmpty
                ? Text(
                    widget.article.title!,
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
            widget.article.description!.isNotEmpty ||
                    widget.article.description! != null
                ? Text(
                    widget.article.description!,
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
                // StreamBuilder<bool>(
                //   stream: getIsLiked.asStream(),
                //   initialData: widget.isLiked,
                //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                //     if (snapshot.hasError ||
                //         !snapshot.hasData ||
                //         snapshot.data == null) {
                //       return const Icon(Icons.favorite_border);
                //     }
                //     return IconButton(
                //       onPressed: () {
                //         widget.isLiked = snapshot.data;

                //         if (widget.isLiked) {
                //           authProvider.unlikePost(widget.article);
                //         } else {
                //           authProvider.likePost(widget.article);
                //         }

                //         setState(() {
                //           widget.isLiked = !widget.isLiked;
                //         });
                //       },
                //       icon: Icon(
                //         snapshot.data ? Icons.favorite : Icons.favorite_border,
                //         color: snapshot.data
                //             ? Colors.red
                //             : themeprovider.isDarkMode
                //                 ? Colors.blue
                //                 : Colors.black,
                //       ),
                //     );
                //   },
                // ),

                GestureDetector(
                  onTap: () {
                    if (widget.isLiked) {
                      authProvider.unlikePost(widget.article);
                    } else {
                      authProvider.likePost(widget.article);
                    }

                    setState(() {
                      widget.isLiked = !widget.isLiked;
                    });
                  },
                  child: FutureBuilder<bool>(
                    future: getIsLiked,
                    initialData: widget.isLiked,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.active ||
                          snapshot.hasData) {
                        return Icon(
                          snapshot.data
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: snapshot.data
                              ? Colors.red
                              : themeprovider.isDarkMode
                                  ? Colors.blue
                                  : Colors.black,
                        );
                      } else if (snapshot.hasError) {
                        return const Icon(Icons.favorite_border,
                            color: Colors.blue);
                      }
                      return const Icon(Icons.favorite_border,
                          color: Colors.blue);
                    },
                  ),
                ),
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
                    Share.share(widget.article.articleUrl!);
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

// ikeButton(
//                         onTap: ((isLiked) async {
//                           isLiked = !isLiked;
//                           print(isLiked);
//                           // authProvider.likePost(widget.article);
//                           // authProvider.isPostLiked(article);
//                           // var isPostLikedInDb =
//                           //     await authProvider.isPostLiked(article);
//                           // isLiked = isPostLikedInDb;
//                           // debugPrint("IS LIKED: $isLiked");
//                           // authProvider.getLikedPostsArray();
//                         }),
//                         size: 15,
//                         circleColor: const CircleColor(
//                           start: kBlue,
//                           end: kBlue,
//                         ),
//                         bubblesColor: const BubblesColor(
//                           dotPrimaryColor: kBlue,
//                           dotSecondaryColor: kBlue,
//                         ),
//                         likeBuilder: (bool isLiked) {
//                           return SvgPicture.asset(
//                             'assets/icons/heart.svg',
//                             color: isLiked
//                                 ? kWarning
//                                 : themeprovider.isDarkMode
//                                     ? kWhite
//                                     : kBlack,
//                             height: 15,
//                             width: 15,
//                           );
//                         },
//                         // likeCount: 665,
//                       );