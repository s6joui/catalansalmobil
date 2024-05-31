import 'dart:convert';

class CommunityMember {
  final String id;
  final String name;
  final String img;

  CommunityMember({
    required this.id,
    required this.name,
    required this.img,
  });

  String get shortName => name.split(' ').first;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'img': img,
    };
  }

  factory CommunityMember.fromMap(Map<String, dynamic> map) {
    return CommunityMember(
      id: map['id'] as String,
      name: map['name'] as String,
      img: map['img'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommunityMember.fromJson(String source) =>
      CommunityMember.fromMap(json.decode(source) as Map<String, dynamic>);
}
