import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/screens/search/tabs/for_you.dart';
import 'package:sportsapp/screens/search/tabs/trending.dart';
import 'package:sportsapp/screens/search/tabs/videos.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // late bool _loading;
  // var newslist = [];

  @override
  Widget build(BuildContext context) {
    // var getPosts = Provider.of<AuthProvider>(context, listen: false).getPosts();
    // TabController tabController = TabController(length: 3, vsync: this);

    //tab bar controller
    var themeProvider = Provider.of<ThemeProvider>(context);
    // final postModel = Provider.of<DataClass>(context);
    return Column(
      children: [
        Container(
          child: Text('data'),
        )
      ],
    );
  }
}
