import 'package:flutter/material.dart';

class MediaTab extends StatefulWidget {
  const MediaTab({Key? key}) : super(key: key);

  @override
  State<MediaTab> createState() => _MediaTabState();
}

class _MediaTabState extends State<MediaTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Media"),
    );
  }
}
