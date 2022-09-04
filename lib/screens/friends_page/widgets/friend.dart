import 'package:flutter/material.dart';
import 'package:sportsapp/helper/constants.dart';

class Friend extends StatelessWidget {
  final String name, username, desc;

  const Friend(
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
              const SizedBox(
                width: 4,
              ),
            ],
          )
        ],
      ),
    );
  }
}
