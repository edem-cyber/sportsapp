import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportsapp/helper/constants.dart';
// import 'package:provider/provider.dart';
// import 'package:sportsapp/providers/AuthProvider.dart';
// import 'package:sportsapp/providers/ThemeProvider.dart';

class Room extends StatelessWidget {
  final String? title, desc, id, image;
  final bool isRead;
  final Function()? onTap;

  const Room({
    Key? key,
    required this.desc,
    required this.title,
    required this.isRead,
    this.onTap,
    this.id,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var authProvider = Provider.of<AuthProvider>(context, listen: false);
    // var themeProvider = Provider.of<ThemeProvider>(context);

    Stream<int> getRepliesLength(String pickId) {
      var doc = FirebaseFirestore.instance.collection('Picks').doc(pickId);
      var comments = doc.collection('replies');
      return comments.snapshots().map((snapshot) => snapshot.size);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 85,
        decoration: BoxDecoration(
          color: isRead ? kGrey.withOpacity(0.1) : kBlue.withOpacity(0.1),
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
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
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
                      ),
              ],
            ),
            StreamBuilder<int>(
              stream: getRepliesLength(id ?? ""),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    children: [
                      Text(
                        "${snapshot.data} replies",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  );
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return const Text("Error");
                }
                return const Text("...");
              },
            )
          ],
        ),
      ),
    );
  }
}
