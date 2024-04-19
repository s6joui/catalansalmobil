import 'package:catalansalmon_flutter/model/community.dart';

abstract class CommunitySearchState {}

class InitCommunitySearchState extends CommunitySearchState {}

class LoadingCommunitySearchState extends CommunitySearchState {}

class ErrorCommunitySearchState extends CommunitySearchState {
  final String message;

  ErrorCommunitySearchState({required this.message});
}

class ResponseCommunitySearchState extends CommunitySearchState {
  final List<Community> results;

  ResponseCommunitySearchState({required this.results});
}