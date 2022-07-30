import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/screens/home/widgets/body.dart';
import 'package:sportsapp/widgets/small_appbar.dart';

class News extends StatelessWidget {
  const News({Key? key}) : super(key: key);
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: SmallAppBar(
        url: authProvider.user!.photoURL ?? AppImage.defaultProfilePicture,
      ),
      body: const Body(),
    );
  }
}
