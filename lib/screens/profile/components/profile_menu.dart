import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    required this.child,
    // this.press,
  }) : super(key: key);

  final String text;
  final Widget child;
  final IconData icon;

  // final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text.rich(
          TextSpan(
            //align children center
            children: <InlineSpan>[
              WidgetSpan(
                // alignment: ,
                child: Icon(
                  icon,
                  // size: 30,
                  // color: Colors.red,
                ),
              ),
              const WidgetSpan(
                child: SizedBox(width: 10),
              ),
              TextSpan(
                text: text,
              ),
            ],
          ),
          // textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
        const Spacer(),
        Transform.scale(
          scale: 0.8,
          child: child,
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
