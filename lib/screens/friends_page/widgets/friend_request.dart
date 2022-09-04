import 'package:flutter/material.dart';
import 'package:sportsapp/helper/constants.dart';

class FriendRequest extends StatelessWidget {
  final String name, username, desc;

  const FriendRequest(
      {Key? key,
      required this.name,
      required this.username,
      required this.desc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 17,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.length > 9
                      ? '${name.substring(0, 10)}... $username'
                      : '$name username',
                  style: Theme.of(context).textTheme.bodyMedium,
                  // maxLines: ,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  desc,
                  maxLines: 3,
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
                // decoration: BoxDecoration(
                //   color: Colors.green,
                // ),
                child: Ink(
                  child: InkWell(
                    onTap: () {},
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
                    onTap: () {},
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
