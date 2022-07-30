import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/providers/AuthProvider.dart';

class SmallAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String url;

  const SmallAppBar({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(
      context,
    );
    return AppBar(
      scrolledUnderElevation: 3,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
        child: CircleAvatar(
          // ignore: prefer_if_null_operators
          backgroundImage: NetworkImage(url),
          radius: 15,
        ),
      ),
      title: const Text(''),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
