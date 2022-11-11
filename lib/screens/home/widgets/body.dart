import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/models/Post.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/screens/home/widgets/news_tile.dart';

class Body extends StatefulWidget {
  //scroll controller
  final ScrollController scrollController;
  const Body({Key? key, required this.scrollController}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    // super.build(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    final getPosts = authProvider.getPosts().asStream();
    return StreamBuilder<List<Article>>(
      initialData: const [],
      stream: getPosts,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Scrollbar(
                controller: widget.scrollController,
                thumbVisibility: true,
                interactive: true,
                child: ListView.separated(
                    controller: widget.scrollController,
                    itemBuilder: (_, int index) {
                      final item = snapshot.data![index];
                      final image =
                          item.urlToImage ?? AppImage.defaultProfilePicture;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: NewsTile(
                          article: item, isLiked: false,
                          // currentUid: authProvider.user!.uid,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: kGrey,
                      );
                    },
                    itemCount: snapshot.data!.length),
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
}
