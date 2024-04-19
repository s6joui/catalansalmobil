// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:catalansalmon_flutter/utils/color_utils.dart';
import 'package:catalansalmon_flutter/utils/string_extension.dart';
import 'package:flutter/material.dart';

import 'package:catalansalmon_flutter/features/community/model/community_member.dart';

class CommunityDetails {
  final String id;
  final String nom;
  final Color color;
  final int numUsuaris;
  final double lat;
  final double lng;
  final String? pais;
  final Map<CommunityInfoParam, String> info;
  final List<CommunityMember> membres;

  CommunityDetails(
      {required this.id,
      required this.nom,
      required this.color,
      required this.numUsuaris,
      required this.lat,
      required this.lng,
      this.pais,
      required this.info,
      required this.membres});

  factory CommunityDetails.fromMap(Map<String, dynamic> map) {
    return CommunityDetails(
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
      pais: map['pais'] != null ? map['pais'] as String : null,
      info: Map<CommunityInfoParam, String>.from(map['info'].map((key, value) =>
          MapEntry(
              CommunityInfoParam.values
                  .firstWhere((e) => e.toString().split('.').last == key),
              value.toString()))),
      membres: List<CommunityMember>.from(
        (map['membres'] as List<dynamic>).map<CommunityMember>(
          (x) => CommunityMember.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  factory CommunityDetails.fromJson(String source) =>
      CommunityDetails.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum CommunityInfoParam { moneda, prefix, horaLocal, padro }

extension ParamExtension on CommunityInfoParam {
  String title() {
    switch (this) {
      case CommunityInfoParam.moneda:
        return 'Moneda';
      case CommunityInfoParam.prefix:
        return 'Prefix telefònic';
      case CommunityInfoParam.horaLocal:
        return 'Hora local';
      case CommunityInfoParam.padro:
        return 'Padró de catalans';
    }
  }

  IconData icon() {
    switch (this) {
      case CommunityInfoParam.moneda:
        return Icons.payments;
      case CommunityInfoParam.prefix:
        return Icons.phone;
      case CommunityInfoParam.horaLocal:
        return Icons.schedule;
      case CommunityInfoParam.padro:
        return Icons.group;
    }
  }
}
