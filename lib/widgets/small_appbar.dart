import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:provider/provider.dart';
// import 'package:sportsapp/providers/AuthProvider.dart';

class SmallAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String url;
  final Function()? action;

  const SmallAppBar({super.key, required this.url, required this.action});

  @override
  Widget build(BuildContext context) {
    // var authProvider = Provider.of<AuthProvider>(
    //   context,
    // );
    return AppBar(
      scrolledUnderElevation: 3,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
        child: GestureDetector(
          onTap: action,
          child: ClipRect(
            child: CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
      title: const SizedBox.shrink(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
