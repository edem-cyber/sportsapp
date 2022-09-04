import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/screens/picks/widgets/body.dart';

class Picks extends StatelessWidget {
  static String routeName = "/picks";
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: true);
    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
          child: GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: CircleAvatar(
              // ignore: prefer_if_null_operators
              backgroundImage: CachedNetworkImageProvider(
                authProvider.user!.photoURL ?? AppImage.defaultProfilePicture,
                errorListener: () {
                  Shimmer.fromColors(
                    baseColor: const Color(0xFF8F8F8F),
                    highlightColor: Colors.white,
                    child: Container(
                      width: 40,
                      height: 40,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              radius: 15,
            ),
          ),
        ),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 0, right: 20, top: 0, bottom: 0),
            child: CircleAvatar(
              // ignore: prefer_if_null_operators
              // backgroundImage: NetworkImage(authProvider.user!.photoURL ??
              //     AppImage.defaultProfilePicture),
              foregroundColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              radius: 15,
            ),
          ),
        ],
        title: Container(
          decoration: BoxDecoration(
            color: kGrey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search Rooms',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: kTextLightColor, fontSize: 14),
            ),
          ),
        ),
        // bottom: const ()
        //,
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                primary: true,
                toolbarHeight: 20,
                collapsedHeight: 35,
                actions: const [SizedBox.shrink()],
                leadingWidth: 0,
                automaticallyImplyLeading: false,
                elevation: 0,
                expandedHeight: 50,
                floating: true,
                pinned: true,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  title: Transform(
                    transform: Matrix4.translationValues(-35.0, 0.0, 0.0),
                    child: Text("News Picks",
                        style: Theme.of(context).appBarTheme.titleTextStyle),
                  ),
                ),
              )
            ];
          },
          body: const Body(),
        ),
      ),
    );
  }
}
