import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/screens/home/widgets/body.dart';
import 'package:sportsapp/widgets/small_appbar.dart';

class News extends StatefulWidget {
  //scroll controller
  final ScrollController scrollController;
  const News({Key? key, required this.scrollController}) : super(key: key);
  static const String routeName = '/home';

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: true);

    return Scaffold(
      appBar: SmallAppBar(
        url: authProvider.user!.photoURL ?? AppImage.defaultProfilePicture,
        action: () {
          // setState(() {
          Scaffold.of(context).openDrawer();
          // });
        },
      ),
      body: Body(
        // key: const Key('homeBody'),
        scrollController: widget.scrollController,
      ),
    );
  }
}
