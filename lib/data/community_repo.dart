import 'dart:convert';
import 'dart:developer';

import 'package:catalansalmon_flutter/features/community/model/community_details.dart';
import 'package:catalansalmon_flutter/features/community/model/community_post.dart';
import 'package:catalansalmon_flutter/features/community/model/community_response.dart';
import 'package:catalansalmon_flutter/features/post/model/post_comment.dart';
import 'package:catalansalmon_flutter/model/community.dart';
import 'package:catalansalmon_flutter/model/success_response.dart';
import 'package:catalansalmon_flutter/secrets.dart';
import 'package:http/http.dart' as http;

class CommunityRepository {
  Future<List<Community>> getNearbyCommunities() async {
    final uri = Uri.parse('$apiUrl/aprop');
    log('HTTP GET $uri');
    final response = await http.get(uri, headers: <String, String>{
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      final List list = json.decode(response.body);
      final List<Community> result =
          list.map((item) => Community.fromMap(item)).toList();
      return result;
    } else {
      throw "Error ${response.statusCode}";
    }
  }

  Future<List<Community>> getAllCommunities() async {
    final uri = Uri.parse('$apiUrl/comunitats');
    log('HTTP GET $uri');
    final response = await http.get(uri, headers: <String, String>{
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      final List list = json.decode(response.body);
      final List<Community> result =
          list.map((item) => Community.fromMap(item)).toList();
      return result;
    } else {
      throw "Error ${response.statusCode}";
    }
  }

  Future<CommunityDetails> getCommunityDetails(String communityId) async {
    final uri = Uri.parse('$apiUrl/comunitats/$communityId');
    log('HTTP GET $uri');
    final response = await http.get(uri, headers: <String, String>{
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      return CommunityDetails.fromJson(response.body);
    } else {
      throw "Error ${response.statusCode}";
    }
  }

  Future<CommunityResponse> getCommunityMembers(String communityId) async {
    final uri = Uri.parse('$apiUrl/comunitats/$communityId/membres');
    log('HTTP GET $uri');
    final response = await http.get(uri, headers: <String, String>{
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      return CommunityResponse.fromJson(response.body);
    } else {
      throw "Error ${response.statusCode}";
    }
  }

  Future<List<CommunityPost>> getCommunityPosts(String communityId, [bool bypassCache = false]) async {
    final uri = Uri.parse('$apiUrl/comunitats/$communityId/posts');
    log('HTTP GET $uri');
    final headers = {
      'Accept': 'application/json',
    };
    if (bypassCache) {
      headers['x-apicache-bypass'] = 'true';
    }
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final List list = json.decode(response.body);
      final List<CommunityPost> result =
          list.map((item) => CommunityPost.fromMap(item)).toList();
      return result;
    } else {
      throw "Error ${response.statusCode}";
    }
  }

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

  Future<bool> createPost(String token, String communityId, String title, String body) async {
    final uri = Uri.parse('$apiUrl/comunitats/$communityId/posts');
    final response = await http.post(uri, headers: <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'token': token,
    }, body: json.encode(<String, String>{'title': title, 'body': body}));
    if (response.statusCode == 200) {
      final success = SuccesReponse.fromJson(response.body).success;
      if (!success) { throw "Error"; }
      return success;
    } else {
      throw "Error ${response.statusCode}";
    }
  }
}
