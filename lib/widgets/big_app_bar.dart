import 'package:flutter/material.dart';
import 'package:sportsapp/helper/constants.dart';

class BigAppBar extends StatelessWidget {
  final title;
  const BigAppBar({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SliverAppBar(
      actions: const [SizedBox.shrink()],
      leadingWidth: 0,
      automaticallyImplyLeading: false,
      backgroundColor: kWhite,
      elevation: 0,
      expandedHeight: size.height * 0.09,
      floating: true,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        title: Transform(
          transform: Matrix4.translationValues(-35.0, 0.0, 0.0),
          child: Text(
            title,
            style: const TextStyle(
                color: kTextColor, fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}
