import 'dart:convert';

class SuccesReponse {
  bool success;

  SuccesReponse(this.success);

  factory SuccesReponse.fromMap(Map<String, dynamic> map) {
    return SuccesReponse(map['success'] as bool);
  }

  factory SuccesReponse.fromJson(String source) =>
      SuccesReponse.fromMap(json.decode(source) as Map<String, dynamic>);
}