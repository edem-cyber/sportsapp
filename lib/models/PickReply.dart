import 'package:cloud_firestore/cloud_firestore.dart';

class PickReply {
  final String? text;
  final String? author;
  final String? timestamp;
  final String? postId;
  final String? type;

  PickReply({this.type, this.text, this.author, this.timestamp, this.postId});

  PickReply.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        author = json['author'],
        timestamp = json['timestamp'],
        type = json['type'],
        postId = json['postId'];

  Map<String, dynamic> toJson() => {
        'text': text,
        'author': author,
        'timestamp': timestamp,
        'postId': postId,
        'type': type
      };

  @override
  String toString() {
    return 'PickReply{text: $text, author: $author, timestamp: $timestamp, postId: $postId ,text: $text, $type: type}';
  }
}
