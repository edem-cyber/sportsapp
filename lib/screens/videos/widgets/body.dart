import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sportsapp/providers/AuthProvider.dart';
// import 'package:sportsapp/providers/ThemeProvider.dart';
// import 'package:sportsapp/providers/navigation_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    // var authProvider = Provider.of<AuthProvider>(context, listen: true);
    // var themeProvider = Provider.of<ThemeProvider>(context);
    // var navigationService = Provider.of<NavigationService>(context);
    // var getLikedPostsArray = authProvider.getLikedPostsArray();
    // var size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: const WebView(
        initialUrl: 'https://www.scorebat.com/video-embed/',
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
      ),
    );
  }
}
