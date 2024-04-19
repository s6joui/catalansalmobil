import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:catalansalmon_flutter/features/auth/model/login_responde.dart';
import 'package:catalansalmon_flutter/secrets.dart';

class AuthRepository {
  static const String _userKey = '_user';
  static const String _passwordKey = '_password';
  static const String _coommunityIdKey = '_community';

  final _storage = const FlutterSecureStorage();

  String? _token;
  String? _user;
  String? _password;
  String? _communityId;

  AuthRepository() {
    log('Init Auth repository');
  }

  bool isLoggedIn() {
    return _user != null && _token != null;
  }

  bool hasSavedCredentials() {
    return _user != null && _password != null && _communityId != null;
  }

  String? get currentCommunityId => _communityId;
  String? get token => _token;

  Future<String> loginWithSavedCredentials() async {
    if (_user == null || _password == null || _communityId == null) { throw "Missing credentials"; } 
    return getAuthToken(_user!, _password!, _communityId!);
  }

  Future<String> getAuthToken(String user, String password, String communityId) async {
    final uri = Uri.parse('$apiUrl/login?idCiutat=$communityId');
    final body =
        json.encode(<String, String>{'user': user, 'password': password});
    log('HTTP POST $uri');
    final response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: body);
    if (response.statusCode == 200) {
      _user = user;
      _password = password;
      _token = LoginResponse.fromJson(response.body).token;
      await _writeToSecureStorage(user, password, communityId);
      return _token!;
    } else {
      throw "Error ${response.statusCode}";
    }
  }

  Future<void> _writeToSecureStorage(
      String user, String password, String communityId) async {
    await _storage.write(key: _userKey, value: user);
    await _storage.write(key: _passwordKey, value: password);
    await _storage.write(key: _coommunityIdKey, value: communityId);
    log('Saved credentials to secure storage');
  }

  Future<void> readCredentials() async {
    _user = await _storage.read(key: _userKey);
    _password = await _storage.read(key: _passwordKey);
    _communityId = await _storage.read(key: _coommunityIdKey);
    log('Read credentials from secure storage');
  }

  Future<void> clearData() async {
    _token = null;
    _user = null;
    _password = null;
    _communityId = null;
    await _storage.deleteAll();
  }
}
