import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/models/Reply.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/screens/comments_page/widgets/body.dart';

class CommentsPage extends StatefulWidget {
  String? id;
  //routename
  static const routeName = '/comments-page';

  CommentsPage({Key? key, this.id}) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  @override
  void initState() {
    super.initState();
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    var navigationService = Provider.of<NavigationService>(context);

    //function to get replies from firebase
    Future<List<Reply>> getReplies({required String id}) async {
      var replies = await FirebaseFirestore.instance
          .collection('Picks')
          .doc(id)
          .collection('replies')
          .get()
          .then((value) => value.docs
              .map((e) => Reply.fromJson(e.data()))
              .toList(growable: false));
      return replies;
    }

    Future<Map<String, dynamic>?> getSinglePick({required String id}) async {
      var pick = await FirebaseFirestore.instance
          .collection('Picks')
          .doc(id)
          .get()
          .then((value) => value.data());
      print("pick is $pick");
      return pick;
    }

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: navigationService.goBack,
          child: const Icon(Icons.arrow_back),
        ),
        backgroundColor: kLightBlue,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: FutureBuilder<Map<String, dynamic>?>(
          future: getSinglePick(id: widget.id!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text("${snapshot.data!['title']}");
            }
            return const Text("Error loading comments");
          },
        ),
      ),
      body: Body(
        scrollController: scrollController,
        id: widget.id,
      ),
    );
  }
}
