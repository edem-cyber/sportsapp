import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';

class NewsTile extends StatelessWidget {
  final String imgUrl, title, desc, content, posturl;

  NewsTile(
      {required this.imgUrl,
      required this.desc,
      required this.title,
      required this.content,
      required this.posturl});

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
    var themeprovider = Provider.of<ThemeProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ArticleView(
        //               postUrl: posturl,
        //             )));
      },
      child: Container(
          // margin: const EdgeInsets.only(bottom: 24),
          // width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          // decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(6),

          // color: themeprovider.isDarkMode ? kBlue : Colors.white,
          // border: Border.symmetric(
          //     horizontal: BorderSide(
          //         color: themeprovider.isDarkMode ? Colors.pink : Colors.grey[150]!,
          //         width: 1)
          //     ),
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
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
                imageUrl: imgUrl,
                placeholder: (context, url) => AspectRatio(
                  aspectRatio: 2,
                  child: Shimmer.fromColors(
                    baseColor: kTextLightColor,
                    highlightColor: const Color(0xFFFFFFFF),
                    child: Container(
                      // height: 100,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  // child: Container(
                  //   // height: 180,
                  //   // width: MediaQuery.of(context).size.width,
                  //   alignment: Alignment.center,
                  //   child: Consumer<ThemeProvider>(
                  //     builder: (context, themeProvider, child) =>
                  //         CupertinoActivityIndicator(
                  //       radius: 15,
                  //       color: themeProvider.isDarkMode ? kWhite : kBlue,
                  //     ),
                  //   ),
                  // ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              //show shimmer when loading

              title.isNotEmpty || title != null
                  ? Text(
                      title,
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

              desc.isNotEmpty || desc != null
                  ? Text(
                      desc,
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
                  LikeButton(
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
                  SvgPicture.asset(
                    shareOptions[1]['icon'] as String,
                    color: themeprovider.isDarkMode ? kWhite : kBlack,
                    height: 15,
                    width: 15,
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
          )),
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