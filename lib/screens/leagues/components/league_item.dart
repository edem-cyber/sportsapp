import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sportsapp/helper/constants.dart';

class LeagueItem extends StatelessWidget {
  final String? image;
  final String? text;
  final Function()? onTap;

  const LeagueItem({this.image, this.text, this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              //                   <--- left side
              color: kGrey.withOpacity(0.2),
              width: 1.0,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: size.width * 0.2,
              child: image != null
                  ? SvgPicture.asset(
                      image!,
                      width: 30,
                    )
                  : Container(),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: size.width * 0.6,
              child: Text(
                text!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
