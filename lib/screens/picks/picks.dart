import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/screens/picks/widgets/body.dart';

class Picks extends StatefulWidget {
  static const String routeName = '/picks';
  const Picks({Key? key}) : super(key: key);

  @override
  State<Picks> createState() => _PicksState();
}


class _PicksState extends State<Picks> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);
    TabController tabController = TabController(length: 3, vsync: this);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
          child: CircleAvatar(
            // ignore: prefer_if_null_operators
            backgroundImage: NetworkImage(
                authProvider.user!.photoURL ?? AppImage.defaultProfilePicture),
            radius: 15,
          ),
        ),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 0, right: 20, top: 0, bottom: 0),
            child: CircleAvatar(
              // ignore: prefer_if_null_operators
              // backgroundImage: NetworkImage(authProvider.user!.photoURL ??
              //     AppImage.defaultProfilePicture),
              foregroundColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              radius: 15,
            ),
          ),
        ],
        title: Container(
          decoration: BoxDecoration(
            color: kGrey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search Rooms',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: kTextLightColor, fontSize: 14),
            ),
          ),
        ),
        //,
      ),
      body: Body(
          // tabController: tabController,
          ),
    );
  }
}

// AppBar(
//       scrolledUnderElevation: 3,
//       leading: Padding(
//         padding: const EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
//         child: CircleAvatar(
//           // ignore: prefer_if_null_operators
//           backgroundImage: NetworkImage(url),
//           radius: 15,
//         ),
//       ),
//       title: const Text(''),
//     );