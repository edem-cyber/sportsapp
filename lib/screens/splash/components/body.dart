import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/screens/splash/components/splash_text.dart';
import 'package:sportsapp/screens/welcome/welcome.dart';
import 'package:sportsapp/providers/navigation_service.dart';
// This is the best practice
import '../components/splash_content.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  // late NavigationService _navigationService;

  final PageController _pageController = PageController();
  List<Map<String, String>> splashData = [
    {
      "text":
          "Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs Guardian Penguins Terriers Buckeyes",
      "image": "assets/images/stad1.png",
      "heading": "Heading 1"
    },
    {
      "text":
          "Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs Guardian Penguins Terriers Buckeyes",
      "image": "assets/images/stad2.png",
      "heading": "Heading 2"
    },
    {
      "text":
          "Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs Guardian Penguins Terriers Buckeyes",
      "image": "assets/images/stad3.png",
      "heading": "Heading 3"
    },
    {
      "text":
          "Leverage SaharaPay to build your portfolio on \nour platform so we pre-finance your large shipments.",
      "image": "assets/images/stad4.png",
      "heading": "Heading 4"
    },
  ];

  void nextPage() {
    _pageController.animateToPage(_pageController.page!.toInt() + 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeOutQuad);
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kWhite : kGrey,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //initialize the nav class
    // _navigationService = GetIt.instance.get<NavigationService>();
    var navigationService =
        Provider.of<NavigationService>(context, listen: false);

    return PageView.builder(
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              //color filter to make the image transparent
              colorFilter:
                  ColorFilter.mode(kBlack.withOpacity(0.4), BlendMode.darken),
              image: AssetImage(splashData[index]["image"]!),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //shiw skip else show nothing
                    TextButton(
                      onPressed: () {
                        navigationService.nagivateRoute(Welcome.routeName);
                      },
                      child: SplashText(
                        text:
                            currentPage != splashData.length - 1 ? "SKIP" : "",
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        if (currentPage < splashData.length - 1) {
                          nextPage();
                        } else {
                          navigationService.nagivateRoute(Welcome.routeName);
                        }
                      },
                      child: currentPage != splashData.length - 1
                          ?
                          //ARROW ICON
                          const Icon(
                              Icons.arrow_forward,
                              color: kWhite,
                              size: 30,
                            )
                          : const SplashText(
                              text: "DONE",
                            ),
                    )
                  ],
                ),
                Positioned(
                  bottom: 20,
                  right: MediaQuery.of(context).size.width * 0.40,
                  left: MediaQuery.of(context).size.width * 0.40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      splashData.length,
                      (index) => buildDot(index: index),
                    ),
                  ),
                ),
                SplashContent(
                  // image: splashData[index]["image"],
                  heading: splashData[index]["heading"],
                  text: splashData[index]["text"],
                ),
              ],
            ),
          )),
      controller: _pageController,
      itemCount: splashData.length,
      onPageChanged: (index) {
        setState(() {
          currentPage = index;
        });
      },
      // child: Container(
      //   // color: kBlack,
      //   decoration: BoxDecoration(
      //     image: DecorationImage(
      //       image: AssetImage("assets/images/splash_bg.png"),
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      //   width: double.infinity,
      //   child: Column(
      //     children: <Widget>[
      //       Expanded(
      //         flex: 3,
      //         child: PageView.builder(
      //           controller: _pageController,
      //           onPageChanged: (value) {
      //             setState(() {
      //               currentPage = value;
      //             });
      //           },
      //           itemCount: splashData.length,
      //           itemBuilder: (context, index) => SplashContent(
      //             image: splashData[index]["image"],
      //             heading: splashData[index]["heading"],
      //             text: splashData[index]['text'],
      //           ),
      //         ),
      //       ),
      // Expanded(
      //   flex: 2,
      //   child: Padding(
      //     padding: EdgeInsets.symmetric(
      //         horizontal: getProportionateScreenWidth(20)),
      //     child: Column(
      //       children: <Widget>[
      //         Spacer(
      //           flex: 3,
      //         ),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: List.generate(
      //             splashData.length,
      //             (index) => buildDot(index: index),
      //           ),
      //         ),
      //         Spacer(),
      //         // DefaultButton(
      //         //   text: "Continue",
      //         //   press: () {
      //         //     Navigator.pushNamed(context, SignInScreen.routeName);
      //         //   },
      //         // ),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             TextButton(
      //               onPressed: () {
      //                 Navigator.pushNamed(
      //                     context, SignInScreen.routeName);
      //               },
      //               child: SplashText(
      //                 text: "SKIP",
      //               ),
      //             ),
      //             currentPage != splashData.length - 1
      //                 ? TextButton.icon(
      //                     onPressed: () {
      //                       if (currentPage < splashData.length - 1) {
      //                         nextPage();
      //                       } else {
      //                         Navigator.pushNamed(
      //                             context, SignInScreen.routeName);
      //                       }
      //                     },
      //                     icon: SplashText(
      //                       text: "NEXT",
      //                     ),
      //                     label: Icon(
      //                       Icons.arrow_forward_ios,
      //                       size: 20,
      //                       color: kPrimaryColor,
      //                     ),
      //                   )
      //                 : ElevatedButton(
      //                     onPressed: () {
      //                       Navigator.pushNamed(
      //                           context, SignInScreen.routeName);
      //                     },
      //                     style: ButtonStyle(
      //                       padding: MaterialStateProperty.all(
      //                           EdgeInsets.symmetric(horizontal: 20)),
      //                       backgroundColor:
      //                           MaterialStateProperty.all<Color>(
      //                         kPrimaryColor,
      //                       ),
      //                     ),
      //                     child: Text(
      //                       "GET STARTED",
      //                       style: TextStyle(
      //                         fontWeight: FontWeight.bold,
      //                       ),
      //                     ),
      //                   ),
      //           ],
      //         ),
      //         Spacer(),
      //       ],
      //     ),
      //   ),
      // ),
      //       ],
      //     ),
      //   ),
    );
  }
}
