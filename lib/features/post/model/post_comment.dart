import 'dart:convert';

class PostComment {
  final String id;
  final String data;
  final String comentari;

  PostComment({
    required this.id,
    required this.data,
    required this.comentari,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'data': data,
      'comentari': comentari,
    };
  }

  factory PostComment.fromMap(Map<String, dynamic> map) {
    return PostComment(
      id: map['id'] as String,
      data: map['data'] as String,
      comentari: map['comentari'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostComment.fromJson(String source) => PostComment.fromMap(json.decode(source) as Map<String, dynamic>);
}
