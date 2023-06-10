import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:url_launcher/url_launcher.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var navigationService = Provider.of<NavigationService>(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: true);

    var getLikedPostsArray = authProvider.getLikedPostsArray();
    var size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          //show list of bookmarks from firebase
          FutureBuilder<List<String>>(
            future: getLikedPostsArray,
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              //if the list is empty
              if (
                  snapshot.connectionState == ConnectionState.none ||
                  !snapshot.hasData) {
                return SizedBox(
                  width: size.width,
                  height: size.height,
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              }
              if (snapshot.data!.isEmpty) {
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
                    return Dismissible(
                      dismissThresholds: const {
                        DismissDirection.endToStart: 0.2,
                        DismissDirection.startToEnd: 0.8,
                      },
                      confirmDismiss: (direction) {
                        return showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                                  title: const Text("Confirm"),
                                  content: const Text("Delete this bookmark?"),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        setState(() {
                                          authProvider.removeFromDb(
                                              snapshot.data![index]);
                                        });
                                        navigationService.goBack();
                                      },
                                      child: const Text("Confirm"),
                                    ),
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        navigationService.goBack();
                                        return;
                                      },
                                      child: const Text("Cancel"),
                                    )
                                  ],
                                ));
                      },
                      background: Container(
                        color: kWarning,
                        child: const Icon(
                          Icons.delete,
                          color: kWhite,
                        ),
                      ),
                      key: UniqueKey(),
                      child: Container(
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
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  authProvider
                                      .removeFromDb(snapshot.data![index]);
                                });
                                // navigationService.goBack();
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: kWarning,
                              ),
                            ),
                          ),
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
          ),
        ],
      ),
    );
  }
}
