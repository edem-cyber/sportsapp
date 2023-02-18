import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsapp/helper/constants.dart';

class FriendRequest extends StatefulWidget {
  final Function()? onTap1, onTap2;
  final String name, username, bio, image;

  const FriendRequest(
      {Key? key,
      required this.name,
      required this.image,
      required this.username,
      required this.bio,
      this.onTap1,
      this.onTap2})
      : super(key: key);

  @override
  State<FriendRequest> createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 17,
            child: CachedNetworkImage(
              imageUrl: widget.image,
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider) => Container(
                // width: 80.0,
                // height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: const CircleAvatar(
                    radius: 40,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name.length > 9
                      ? '${widget.name.substring(0, 10)}... ${widget.username}'
                      : '${widget.name} ${widget.username}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  // maxLines: ,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  widget.bio.length > 10
                      ? widget.bio.substring(0, 10)
                      : widget.bio,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodySmall,
                  // maxLines: ,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                height: 25,
                alignment: Alignment.center,
                width: 70,
                child: Ink(
                  child: InkWell(
                    onTap: () {
                      // setState(() {
                      widget.onTap1!();
                      // });
                    },
                    child: Text(
                      'Accept',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: kWhite),
                    ), // other widget
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: kWarning,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                height: 25,
                alignment: Alignment.center,
                width: 70,
                // decoration: BoxDecoration(
                //   color: Colors.green,
                // ),
                child: Ink(
                  child: InkWell(
                    onTap: () {
                      widget.onTap2!();
                    },
                    child: Text(
                      'Decline',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: kWhite),
                    ), // other widget
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
