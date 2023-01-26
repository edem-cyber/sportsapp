import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
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
    var themeProvider = Provider.of<ThemeProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: true);
    var navigationService = Provider.of<NavigationService>(context);
    final FirebaseFirestore _dataBase = FirebaseFirestore.instance;
    var userProfile = authProvider.getProfileData(id: widget.id);
    var userData = authProvider.getUserData();
    // var getLikedPostsArray = _databaseService.getLikedPostsArray(
    //   uid: authProvider.user!.uid,
    // );

    Stream<List<String>> getLikedPostsArrayStream({required String uid}) {
      return _dataBase
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

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        StreamBuilder<List<String>>(
          stream: getLikedPostsArrayStream(
            uid: widget.id,
          ),
          initialData: const [],
          builder: (context, snapshot) {
            var likedPosts = snapshot.data;
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: likedPosts!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: widget.id == authProvider.user!.uid
                        ? Dismissible(
                            confirmDismiss: (direction) {
                              return showDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                  title: const Text("Confirm"),
                                  content: const Text(
                                      "Are you sure you want to delete this item?"),
                                  actions: [
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        // authProvider
                                        //     .removeFromDb(snapshot.data![index]);
                                        // navigationService.goBack();
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text("DELETE"),
                                    ),
                                    CupertinoDialogAction(
                                      onPressed: () =>
                                          navigationService.goBack(),
                                      child: const Text("CANCEL"),
                                    ),
                                  ],
                                ),
                              );
                            },
                            background: Container(
                              color: kWarning,
                              child: const Icon(Icons.delete),
                            ),
                            behavior: HitTestBehavior.translucent,
                            key: UniqueKey(),
                            child: ListTile(
                              onTap: () async {
                                if (await canLaunchUrl(
                                    Uri.parse(likedPosts[index]))) {
                                  await launchUrl(Uri.parse(likedPosts[index]));
                                } else {
                                  throw 'Could not launch ${snapshot.data![index]}';
                                }
                              },
                              title: Text(
                                likedPosts[index],
                                maxLines: 2,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  //remove from list tile
                                  setState(() {
                                    removeListTile(likedPosts[index]);
                                  });
                                  // snapshot.data![index].remove(index);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ),
                          )
                        : ListTile(
                            onTap: () async {
                              if (await canLaunchUrl(
                                  Uri.parse(likedPosts[index]))) {
                                await launchUrl(Uri.parse(likedPosts[index]));
                              } else {
                                throw 'Could not launch ${snapshot.data![index]}';
                              }
                            },
                            title: Text(
                              likedPosts[index],
                              maxLines: 2,
                            ),
                            // trailing: IconButton(
                            //   onPressed: () {
                            //     //remove from list tile
                            //     setState(() {
                            //       removeListTile(likedPosts[index]);
                            //     });
                            //     // snapshot.data![index].remove(index);
                            //   },
                            //   icon: const Icon(Icons.delete),
                            // ),
                          ),
                  );
                },
              );
            } else if (snapshot.hasError ||
                snapshot.data == null ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text(
                  'No bookmarks',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ],
    );
  }
}
