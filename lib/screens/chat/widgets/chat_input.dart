import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportsapp/models/Reply.dart';

class ReplyInput extends StatefulWidget {
  const ReplyInput({Key? key}) : super(key: key);

  @override
  _ReplyInputState createState() => _ReplyInputState();
}

class _ReplyInputState extends State<ReplyInput> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void addReply(Reply reply) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(reply.postId)
          .collection('replies')
          .add(
        {
          'text': reply.text,
          'author': reply.author,
          'timestamp': reply.timestamp,
          'postId': reply.postId,
        },
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Reply'),
            controller: _textController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a reply';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Retrieve the input text and add the reply
                String replyText = _textController.text;
                addReply(
                  Reply(
                    text: replyText,
                    timestamp: Timestamp.now().toString(),
                  ),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
