import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
// import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/services/database_service.dart';
import 'package:url_launcher/url_launcher.dart';

class LikesTab extends StatefulWidget {
  const LikesTab({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;

  @override
  State<LikesTab> createState() => _LikesTabState();
}

class _LikesTabState extends State<LikesTab> {
  @override
  Widget build(BuildContext context) {
    // var themeProvider = Provider.of<ThemeProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: true);
    var navigationService = Provider.of<NavigationService>(context);
    final FirebaseFirestore dataBase = FirebaseFirestore.instance;
    // var userProfile = authProvider.getProfileData(id: widget.id);
    // var userData = authProvider.getUserData();
    // var getLikedPostsArray = _databaseService.getLikedPostsArray(
    //   uid: authProvider.user!.uid,
    // );

    Stream<List<String>> getLikedPostsArrayStream({required String uid}) {
      return dataBase
          .collection(userCollection)
          .doc(uid)
          .snapshots()
          .map((snapshot) {
        return List<String>.from(snapshot.data()![postDoc]);
      });
    }

    void removeListTile(String postUrl) {
      // authProvider.removeFromDb(postUrl);
    }
    var getLikedPostsArray = authProvider.getLikedPostsArray();
    var size = MediaQuery.of(context).size;
    var themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder<List<String>>(
      initialData: const [],
      future: getLikedPostsArray,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        //if the list is empty
        if (snapshot.connectionState == ConnectionState.none) {
          return SizedBox(
            width: size.width,
            height: size.height,
            child: const Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }
        if (snapshot.data!.isEmpty || !snapshot.hasData) {
          return SizedBox(
            width: size.width,
            height: size.height,
            child: Center(
              child: Text(
                "No Bookmarks",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          return ListView.separated(
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 15,
              );
            },
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: themeProvider.isDarkMode
                          ? const Color.fromARGB(255, 32, 32, 32)
                          : const Color(0xFFF7F7F7),
                      spreadRadius: 2,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  onTap: () {
                    launchUrl(
                      Uri.parse(
                        snapshot.data![index],
                      ),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: ListTile(
                    title: Text(
                      snapshot.data![index],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    // trailing: IconButton(
                    //   onPressed: () {
                    //     // setState(() {
                    //     //   authProvider.removeFromDb(snapshot.data![index]);
                    //     // });
                    //     // navigationService.goBack();
                    //   },
                    //   icon: const Icon(
                    //     Icons.delete,
                    //     color: kWarning,
                    //   ),
                    // ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
      },
    );
  }
}
