import 'package:flutter/material.dart';

class DirectMessage extends StatelessWidget {
  const DirectMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Direct Message"),
      ),
      body: const Center(
        child: Text("Direct Message"),
      ),
    );
  }
}
