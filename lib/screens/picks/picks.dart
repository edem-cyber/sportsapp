import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/screens/picks/widgets/body.dart';

class Picks extends StatefulWidget {
  static String routeName = "/picks";

  @override
  State<Picks> createState() => _PicksState();
}

class _PicksState extends State<Picks> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: true);
    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    var size = MediaQuery.of(context).size;

    var isAdmin = authProvider.isAdmin();

    //texteditting controllers
    TextEditingController pickTitleController = TextEditingController();
    TextEditingController pickDescriptionController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    TextFormField buildPickTitleFormField() {
      return TextFormField(
        controller: pickTitleController,
        validator: (value) {
          if (value!.isEmpty) {
            return;
          }
          return;
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Enter Pick Title",
          // floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      );
    }

    TextFormField buildPickDescriptionFormField() {
      return TextFormField(
        controller: pickDescriptionController,
        validator: (value) {
          if (value!.isEmpty) {
            return;
          }
          return;
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Enter Pick Description",
          // floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      );
    }

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
              hintText: 'Search Picks',
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
        child: FutureBuilder<bool>(
          future: authProvider.isAdmin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (snapshot.data == null || snapshot.hasError) {
              return const Center(child: Text("Error"));
            }

            if (snapshot.hasData && snapshot.data == true) {
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  backgroundColor: kBlue,
                  foregroundColor: kWhite,
                  onPressed: () {
                    //Open Modal
                    showModalBottomSheet(
                        isDismissible: true,
                        clipBehavior: Clip.antiAlias,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        enableDrag: true,
                        //set anchor point to top
                        isScrollControlled: true,
                        anchorPoint: const Offset(0, 1),
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: size.height * 0.95,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                //form to create room
                                SafeArea(
                                  child: Form(
                                    key: formKey,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 20, bottom: 20),
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // const SizedBox(height: 10),
                                          Text("News Picks",
                                              style: Theme.of(context)
                                                  .appBarTheme
                                                  .titleTextStyle),
                                          const SizedBox(height: 10),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 25),
                                            decoration: BoxDecoration(
                                              color: kGrey.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                            ),
                                            child: buildPickTitleFormField(),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 25),
                                            decoration: BoxDecoration(
                                              color: kGrey.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                            ),
                                            child:
                                                buildPickDescriptionFormField(),
                                          ),
                                          const SizedBox(height: 20),
                                          //create room button
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 25),
                                            decoration: BoxDecoration(
                                              color: kBlue,
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                            ),
                                            child: TextButton(
                                              onPressed: () {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  formKey.currentState!.save();

                                                  setState(() {
                                                    authProvider.createPick(
                                                        title:
                                                            pickTitleController
                                                                .text,
                                                        desc:
                                                            pickDescriptionController
                                                                .text);
                                                  });
                                                  //create room
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text("Create Pick",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: const Icon(Icons.add),
                ),
                body: NestedScrollView(
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
                            transform:
                                Matrix4.translationValues(-35.0, 0.0, 0.0),
                            child: Text("News Picks",
                                style: Theme.of(context)
                                    .appBarTheme
                                    .titleTextStyle),
                          ),
                        ),
                      )
                    ];
                  },
                  body: const Body(),
                ),
              );
            }
            return NestedScrollView(
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
                            style:
                                Theme.of(context).appBarTheme.titleTextStyle),
                      ),
                    ),
                  )
                ];
              },
              body: const Body(),
            );
          },
        ),
      ),
    );

    // return Body();
  }
}
