import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/models/Post.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/widgets/news_tile.dart';

class Body extends StatefulWidget {
  //scroll controller
  final ScrollController scrollController;
  const Body({Key? key, required this.scrollController}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with AutomaticKeepAliveClientMixin {
  // late bool _loading;
  // var newslist = [];
  // late Stream<List<Article>> stream;

  @override
  void initState() {
    super.initState();
    //IF YOU WANT TO USE THE STREAM, YOU NEED TO ADD THE PROVIDER TO THE SCREEN
    // var getPosts = Provider.of<AuthProvider>(context, listen: false).getPosts();
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.getPosts();
    // stream = getPosts.stream;
    // return logexpertClient.objectsState.read(object.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    final getPosts = authProvider.getPosts().asStream();
    // if (authProvider.user != null) {
    // stream = getPosts.asStream();
    //   // stream = Stream.periodic(const Duration(seconds: 40)).asyncMap((_) async {
    //   //   print('REQUESTING POSTS');
    //   //   return await getPosts;
    //   //   // return logexpertClient.objectsState.read(object.id);
    //   // });
    // } else {
    //   stream = Stream.value([]);
    //   return Center(
    //     child: Text(
    //       'Error: Sign in to see posts',
    //       style: Theme.of(context).textTheme.bodyLarge,
    //     ),
    //   );
    // }
    // var scrollController = ScrollController();
    // final postModel = Provider.of<DataClass>(context);
    return Container(
        // padding: const EdgeInsets.symmetric(horizontal: 15),
        child: StreamBuilder<List<Article>>(
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
                          imgUrl: image,
                          title: item.title ?? "",
                          desc: item.description ?? "",
                          content: item.content ?? "",
                          posturl: item.articleUrl ?? "",
                          isLiked: false,
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
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
