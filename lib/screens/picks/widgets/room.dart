import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';

class Room extends StatelessWidget {
  final String? title, desc, comments, likes, id;
  final bool isRead;
  final Function()? onTap;

  const Room(
      {Key? key,
      required this.desc,
      required this.title,
      this.comments,
      this.likes,
      required this.isRead,
      this.onTap,
      this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var themeProvider = Provider.of<ThemeProvider>(context);
    // Future<Map<String, dynamic>?> getSinglePick({required String id}) async {
    //   var pick = await FirebaseFirestore.instance
    //       .collection('picks')
    //       .doc(id)
    //       .get()
    //       .then((value) => value.data());
    //   return pick;
    // }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 85,
        decoration: BoxDecoration(
          color: isRead ? kBlue.withOpacity(0.1) : kBlue.withOpacity(0.1),
          border: Border(
            // top: BorderSide(width: 16.0, color: Colors.lightBlue.shade50),
            bottom: BorderSide(width: 1.0, color: kGrey.withOpacity(0.2)),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    desc ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                // const Spacer(),
                const SizedBox(
                  width: 5,
                ),
                isRead == true
                    ? const CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.transparent,
                      )
                    : const CircleAvatar(
                        radius: 15,
                        // backgroundColor: Colors.transparent,
                      ),
              ],
            ),
            Row(
              children: [
                Text(
                  "7 comments",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "7 likes",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            )
            // Divider(
            //   color: kGrey,
            // )
          ],
        ),
      ),
    );
  }
}
