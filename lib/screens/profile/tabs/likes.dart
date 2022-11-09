import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:url_launcher/url_launcher.dart';

class LikesTab extends StatefulWidget {
  const LikesTab({Key? key}) : super(key: key);

  @override
  State<LikesTab> createState() => _LikesTabState();
}

class _LikesTabState extends State<LikesTab> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: true);
    var navigationService = Provider.of<NavigationService>(context);
    final getLikedPostsArray = authProvider.getLikedPostsArray().asStream();
    void removeListTile(String postUrl) {
      authProvider.removeFromDb(postUrl);
    }

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        StreamBuilder<List<String>>(
          stream: getLikedPostsArray,
          initialData: const [],
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Dismissible(
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
                                  authProvider
                                      .removeFromDb(snapshot.data![index]);
                                  // navigationService.goBack();
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text("DELETE"),
                              ),
                              CupertinoDialogAction(
                                onPressed: () => navigationService.goBack(),
                                child: const Text("CANCEL"),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) {
                        authProvider.removeFromDb(snapshot.data![index]);
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
                              Uri.parse(snapshot.data![index]))) {
                            await launchUrl(Uri.parse(snapshot.data![index]));
                          } else {
                            throw 'Could not launch ${snapshot.data![index]}';
                          }
                        },
                        title: Text(
                          snapshot.data![index],
                          maxLines: 2,
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            //remove from list tile
                            setState(() {
                              removeListTile(snapshot.data![index]);
                            });
                            // snapshot.data![index].remove(index);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }
}
