import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/models/Post.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/widgets/post.dart';
import 'package:sportsapp/services/getposts.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with AutomaticKeepAliveClientMixin {
  // late bool _loading;
  // var newslist = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var getPosts = Provider.of<AuthProvider>(context, listen: false).getPosts();
    // final postModel = Provider.of<DataClass>(context);
    return Container(
        // padding: const EdgeInsets.symmetric(horizontal: 15),
        child: FutureBuilder<List<Article>>(
      future: getPosts,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.separated(
                itemBuilder: (_, int index) {
                  final item = snapshot.data![index];
                  final image = item.urlToImage;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: NewsTile(
                      imgUrl: image ?? "",
                      title: item.title ?? "",
                      desc: item.description ?? "",
                      content: item.content ?? "",
                      posturl: item.articleUrl ?? "",
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: kGrey.withOpacity(0.5),
                  );
                },
                itemCount: snapshot.data!.length)

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

// .builder(
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (_, int index) {
//                       final item = snapshot.data![index];
//                       final image = item.urlToImage;
//                       return NewsTile(
//                         imgUrl: image ?? "",
//                         title: item.title ?? "",
//                         desc: item.description ?? "",
//                         content: item.content ?? "",
//                         posturl: item.articleUrl ?? "",
//                       );
//                     },
//                   )