import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/models/Reply.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/screens/comments_page/widgets/body.dart';

class CommentsPage extends StatelessWidget {
  String? id;
  //routename
  static const routeName = '/comments-page';

  CommentsPage({Key? key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var navigationService = Provider.of<NavigationService>(context);
    //function to get replies from firebase
    print("id is $id");

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
      body: Body(
        id: id,
      ),
    );
  }
}
