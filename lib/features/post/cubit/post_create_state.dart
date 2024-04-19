import 'package:catalansalmon_flutter/features/post/model/post_comment.dart';

abstract class PostCreateState {}

class InitPostCreateState extends PostCreateState {}

class SendingPostCreateState extends PostCreateState {}

class ErrorPostCreateState extends PostCreateState {
  final String message;

  ErrorPostCreateState({required this.message});
}

class SuccessPostCreateState extends PostCreateState {
  final List<PostComment> comments;

  SuccessPostCreateState({required this.comments});
}