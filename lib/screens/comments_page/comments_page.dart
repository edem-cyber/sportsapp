import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/screens/comments_page/widgets/body.dart';

class CommentsPage extends StatelessWidget {
  //routename
  static const routeName = '/comments-page';
  const CommentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var navigationService = Provider.of<NavigationService>(context);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: navigationService.goBack,
          child: const Icon(Icons.arrow_back),
        ),
        backgroundColor: kLightBlue,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text("Room 1"),
      ),
      body: const Body(),
    );
  }
}
