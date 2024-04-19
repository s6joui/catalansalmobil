// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:catalansalmon_flutter/features/community/model/community_details.dart';
import 'package:catalansalmon_flutter/features/community/model/community_member.dart';
import 'package:catalansalmon_flutter/features/community/model/community_post.dart';
import 'package:catalansalmon_flutter/model/community.dart';

abstract class CommunityState {}

class InitCommunityState extends CommunityState {}

class LoadingCommunityState extends CommunityState {}

class ErrorCommunityState extends CommunityState {
  final String message;

  ErrorCommunityState({required this.message});
}

class ResponseCommunityState extends CommunityState {
  final Community community;
  final CommunityDetails details;
  final List<CommunityPost> posts;
  bool isLoggedIn;

  ResponseCommunityState(this.community, this.details, this.posts,
      [this.isLoggedIn = false]);

  ResponseCommunityState copyWith({
    Community? community,
    CommunityDetails? details,
    List<CommunityPost>? posts,
    bool? isLoggedIn,
  }) {
    return ResponseCommunityState(
        community ?? this.community,
        details ?? this.details,
        posts ?? this.posts,
        isLoggedIn ?? this.isLoggedIn);
  }
}
