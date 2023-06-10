import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/models/Post.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/screens/home/widgets/news_tile.dart';

class Videos extends StatefulWidget {
  const Videos({Key? key}) : super(key: key);

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var getPosts = Provider.of<AuthProvider>(context, listen: false).getPosts();
    var themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder<List<Article>>(
      future: getPosts,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      // color: ,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(errorListener: () {
                          print('error');
                        }, "https://images.unsplash.com/photo-1579952363873-27f3bade9f55?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3), BlendMode.darken),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.only(
                              right: 20, left: 5, top: 5, bottom: 5),
                          color: kTertiaryColor,
                          child: Text(
                            "Paid Advertisement",
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: kBlack,
                                    ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Description",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: themeProvider.isDarkMode
                                              ? kBlack
                                              : kWhite),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Description",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: themeProvider.isDarkMode
                                              ? kBlack
                                              : kWhite),
                                ),
                                ElevatedButton(
                                  //set elevated button color
                                  style: ElevatedButton.styleFrom(
                                    // set foreground color
                                    // shadowColor: Colors.black,
                                    backgroundColor: kTertiaryColor,
                                    splashFactory: NoSplash.splashFactory,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    // set shadow color
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    "Buy Tickets",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: kBlack,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (_, int index) {
                      final item = snapshot.data![index];
                      final image = item.urlToImage;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: NewsTile(
                          article: item,
                          isLiked: false,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: kGrey.withOpacity(0.5),
                      );
                    },
                    itemCount: snapshot.data!.length,
                  )
                ],
              )

            // }), separatorBuilder: separatorBuilder, itemCount: itemCount)
            : Center(
                child: Consumer<ThemeProvider>(
                  builder: (context, ThemeProvider themeProvider, child) {
                    return CupertinoActivityIndicator(
                      radius: 20,
                      color: themeProvider.isDarkMode ? kWhite : kBlue,
                    );
                  },
                ),
              );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
