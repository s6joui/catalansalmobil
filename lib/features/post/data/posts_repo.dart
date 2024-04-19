import 'dart:convert';

import 'package:catalansalmon_flutter/features/post/model/post_comment.dart';
import 'package:catalansalmon_flutter/secrets.dart';
import 'package:http/http.dart' as http;

class PostsRepository {
  Future<List<PostComment>> getPostComments(
      String communityId, String postId) async {
    final uri = Uri.parse('$apiUrl/comunitats/$communityId/posts/$postId');
    final response = await http.get(uri, headers: <String, String>{
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      final List list = json.decode(response.body);
      final List<PostComment> result =
          list.map((item) => PostComment.fromMap(item)).toList();
      return result;
    } else {
      throw "Error ${response.statusCode}";
    }
  }

  Future<List<PostComment>> createComment(String token, String communityId, String postId, String comment) async {
    final uri = Uri.parse('$apiUrl/comunitats/$communityId/posts/$postId');
    final response = await http.post(uri, headers: <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'token': token,
    }, body: json.encode(<String, String>{'comment': comment}));
    if (response.statusCode == 200) {
      final List list = json.decode(response.body);
      final List<PostComment> result =
          list.map((item) => PostComment.fromMap(item)).toList();
      return result;
    } else {
      throw "Error ${response.statusCode}";
    }
  }
}