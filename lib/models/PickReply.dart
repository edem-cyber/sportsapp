import 'package:cloud_firestore/cloud_firestore.dart';

class PickReply {
  final String? text;
  final String? author;
  final String? timestamp;
  final String? postId;

  PickReply({this.text, this.author, this.timestamp, this.postId});

  PickReply.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        author = json['author'],
        timestamp = json['timestamp'],
        postId = json['postId'];

  Map<String, dynamic> toJson() => {
        'text': text,
        'author': author,
        'timestamp': timestamp,
        'postId': postId,
      };

  @override
  String toString() {
    return 'PickReply{text: $text, author: $author, timestamp: $timestamp, postId: $postId}';
  }
}
