import 'dart:convert';

class CommunityPost {
  final String id;
  final String title;
  final String link;
  final String user;
  final String date;
  final String body;
  
  CommunityPost({
    required this.id,
    required this.title,
    required this.link,
    required this.user,
    required this.date,
    required this.body,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'link': link,
      'user': user,
      'date': date,
      'body': body,
    };
  }

  factory CommunityPost.fromMap(Map<String, dynamic> map) {
    return CommunityPost(
      id: map['id'] as String,
      title: (map['title'] as String).replaceAll('\n', ' '),
      link: map['link'] as String,
      user: map['user'] as String,
      date: map['date'] as String,
      body: map['body'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommunityPost.fromJson(String source) => CommunityPost.fromMap(json.decode(source) as Map<String, dynamic>);
}
