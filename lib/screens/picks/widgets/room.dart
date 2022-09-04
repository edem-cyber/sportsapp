import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';

class Room extends StatelessWidget {
  final String title, desc, comments, likes;
  final bool isRead;
  final Function()? onTap;

  const Room(
      {required this.desc,
      required this.title,
      required this.comments,
      required this.likes,
      required this.isRead,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 85,
        decoration: BoxDecoration(
          color: isRead ? kBlue.withOpacity(0.1) : kWhite,
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
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    desc,
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
                  "$comments Comments",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "$likes Likes",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
            // Divider(
            //   color: kGrey,
            // )
          ],
        ),
      ),
    );
  }
}
