import 'dart:math';

import 'package:flutter/material.dart';

class RoomsTab extends StatefulWidget {
  final String? id;
  const RoomsTab({Key? key, this.id}) : super(key: key);

  @override
  State<RoomsTab> createState() => _RoomsState();
}

class _RoomsState extends State<RoomsTab> {
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 2,
        itemBuilder: (context, index) {
          return const RoomProfile(
            id: 'id',
            name: 'name',
            description: 'description',
            creator: 'creator',
            members: ['member1', 'member2'],
          );
        },
      ),
    );
  }
}

// RoomProfile profile widget
class RoomProfile extends StatelessWidget {
  final String? id;
  final String? name;
  final String? description;
  final String? creator;
  final List<String>? members;

  const RoomProfile(
      {super.key,
      this.id,
      this.name,
      this.description,
      this.creator,
      this.members});

  @override
  Widget build(BuildContext context) {
    // list of colors that will be used to color the room
    final List<Color> colors = [
      Colors.orange,
      Colors.teal,
      Colors.cyan,
      Colors.brown,
      // Colors.lightBlue,
      Colors.lightGreen,
      Colors.deepOrange,
      Colors.deepPurple,
      Colors.blueGrey,
    ];

    // function to pick random color from the list
    Color getRandomColor() {
      final _random = Random();
      return colors[_random.nextInt(colors.length)];
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        color: getRandomColor(),
        // boxShadow: const [
        //   BoxShadow(
        //     // color: Colors.grey.withOpacity(0.5),
        //     spreadRadius: 1,
        //     blurRadius: 7,
        //     offset: Offset(0, 3), // changes position of shadow
        //   ),
        // ],
      ),
      height: 80,
      child: Center(
        child: Text("$name", style: const TextStyle(color: Colors.white)),
      ),
      // loop through the colors list and pick a random color
    );
  }
}
