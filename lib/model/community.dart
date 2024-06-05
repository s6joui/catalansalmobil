// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ui';

import 'package:catalansalmon_flutter/features/community/model/community_details.dart';
import 'package:catalansalmon_flutter/utils/color_utils.dart';
import 'package:catalansalmon_flutter/utils/string_extension.dart';
import 'package:flutter/material.dart';

class Community {
  final String id;
  final String nom;
  final Color color;
  final int numUsuaris;
  final double lat;
  final double lng;

  Community({
    required this.id,
    required this.nom,
    required this.color,
    required this.numUsuaris,
    required this.lat,
    required this.lng,
  });

  factory Community.fromCommunityDetails(CommunityDetails details) {
    return Community(
        id: details.id,
        nom: details.nom,
        color: details.color,
        numUsuaris: details.numUsuaris,
        lat: details.lat,
        lng: details.lng);
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id'] as String,
      nom: (map['nom'] as String).capitalizeByWord(),
      color: hexStringToColor(map['color'] as String),
      numUsuaris: map['numUsuaris'] as int,
      lat: map['lat'] is double
          ? map['lat'] as double
          : (map['lat'] as int).toDouble(),
      lng: map['lng'] is double
          ? map['lng'] as double
          : (map['lng'] as int).toDouble(),
    );
  }

  factory Community.fromJson(String source) =>
      Community.fromMap(json.decode(source) as Map<String, dynamic>);
}
