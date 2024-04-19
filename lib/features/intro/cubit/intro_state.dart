import 'package:catalansalmon_flutter/features/community/model/community_details.dart';
import 'package:catalansalmon_flutter/model/community.dart';

abstract class IntroState {}

class InitIntroState extends IntroState {}

class LoadingIntroState extends IntroState {}

class ErrorIntroState extends IntroState {
  final String message;

  ErrorIntroState({required this.message});
}

class LoginSuccessIntroState extends IntroState {
  final CommunityDetails details;
  
  LoginSuccessIntroState(this.details);
}

class ResponseIntroState extends IntroState {
  final List<Community> nearbyCommunities;

  ResponseIntroState({required this.nearbyCommunities});
}