import 'dart:convert';

import 'package:catalansalmon_flutter/features/community/model/community_member.dart';

class CommunityResponse {
  final List<CommunityMember> membres;
  final String titol;
  CommunityResponse({
    required this.membres,
    required this.titol,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'membres': membres.map((x) => x.toMap()).toList(),
      'titol': titol,
    };
  }

  factory CommunityResponse.fromMap(Map<String, dynamic> map) {
    return CommunityResponse(
      membres: List<CommunityMember>.from((map['membres'] as List<dynamic>).map<CommunityMember>((x) => CommunityMember.fromMap(x as Map<String,dynamic>),),),
      titol: map['titol'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommunityResponse.fromJson(String source) => CommunityResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
