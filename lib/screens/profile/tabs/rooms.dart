import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class RoomsTab extends StatefulWidget {
  const RoomsTab({Key? key}) : super(key: key);

  @override
  State<RoomsTab> createState() => _RoomsState();
}

class _RoomsState extends State<RoomsTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("RoomsTab"),
    );
  }
}
