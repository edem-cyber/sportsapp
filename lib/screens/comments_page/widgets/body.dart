import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/screens/comments_page/widgets/comment.dart';
import 'package:sticky_headers/sticky_headers.dart';


class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: true);

    var themeProvider = Provider.of<ThemeProvider>(context);
    var navigationService = Provider.of<NavigationService>(context);
    return SafeArea(
      child: Column(
        children: [
          IntrinsicHeight(
            
            child: Container(
              padding: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: kGrey.withOpacity(0.4),
                borderRadius: const BorderRadius.all(
                  Radius.circular(40),
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: kLightBlue,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      Text(
                        "MESSI Leave Barca",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs Guardian Penguins. Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs Guardian Penguins. Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs Guardian Penguins. Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs Guardian Penguins. Cavs Guardian Penguins. Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs Guardian ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Comments & Replies",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: const EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          height: 50,
                          child: const VerticalDivider(
                            color: kGrey,
                          ),
                        );
                      },
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return Comment(
                            image: authProvider.user!.photoURL ??
                                AppImage.defaultProfilePicture,
                            text:
                                "Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs Guardian Penguins.");
                      },
                    ),
                  ),
                  // Container(
                  //   color: kBlack,
                  //   height: 20,
                  // ),
                  Container(
                    padding: const EdgeInsets.only(top: 7),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          // backgroundColor: kBlue,
                          // elevation: 0,
                          child: Container(
                            padding: const EdgeInsets.only(
                              right: 10,
                              top: 15,
                              bottom: 15,
                            ),
                            child: const Icon(
                              Icons.image_outlined,
                              color: kBlue,
                              size: 18,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Theme(
                            data: ThemeData(
                              textSelectionTheme: const TextSelectionThemeData(
                                  selectionColor: kLightBlue),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: kGrey.withOpacity(0.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "Start a message...",
                                hintStyle:
                                    Theme.of(context).textTheme.bodyLarge,
                              ),
                              textInputAction: TextInputAction.newline,
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   width: 15,
                        // ),
                        GestureDetector(
                          onTap: () {},
                          // backgroundColor: kBlue,
                          // elevation: 0,
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 10,
                              top: 15,
                              bottom: 15,
                            ),
                            child: const Icon(
                              Icons.send,
                              color: kBlue,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
