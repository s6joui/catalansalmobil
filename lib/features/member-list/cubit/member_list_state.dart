part of 'member_list_cubit.dart';

@immutable
sealed class MemberListState {}

class InitMemberListState extends MemberListState {}

class LoadingMemberListState extends MemberListState {}

class ErrorMemberListState extends MemberListState {
  final String message;

  ErrorMemberListState({required this.message});
}

class ResponseMemberListState extends MemberListState {
  final List<CommunityMember> results;

  ResponseMemberListState({required this.results});
}
