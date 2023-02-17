import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/providers/AuthProvider.dart';

class Body extends StatefulWidget {
  final String? roomId, roomName, roomDescription, roomImage;
  final List<String>? roomMembers;
  const Body({
    super.key,
    this.roomId,
    this.roomName,
    this.roomDescription,
    this.roomMembers,
    this.roomImage,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Stream<List<Map<String, dynamic>>> getRoomMessages(String roomId) {
    return FirebaseFirestore.instance
        .collection('Rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map((messagesSnapshot) => messagesSnapshot.docs.map((doc) {
              final data = doc.data();
              final id = doc.id;
              final message = {
                'id': id,
                'text': data['text'],
                'userId': data['userId'],
                'createdAt': data['createdAt'],
              };
              return message;
            }).toList());
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    var profile = authProvider.getProfileData(id: authProvider.user!.uid);
    return StreamBuilder<Object>(
        stream: getRoomMessages(widget.roomId ?? ''),
        builder: (context, snapshot) {
          return Column(
            children: [
              // Text(widget.roomId ?? ''),
              // Text(widget.roomName ?? ''),
              // Text(widget.roomDescription ?? ''),
              // Text(widget.roomMembers![0]),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.roomMembers!.length,
                itemBuilder: (context, index) {
                  // String uid = widget.roomMembers![index];
                  return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    future: profile,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> userData = snapshot.data!.data()!;
                        // Display user information in a widget
                        return Text(userData['displayName']);
                      } else {
                        // Show a loading indicator while waiting for data
                        return CircularProgressIndicator();
                      }
                    },
                  );
                },
              ),
            ],
          );
        });
  }
}
