import 'package:catalansalmon_flutter/features/post/model/post_comment.dart';

abstract class CommentState {}

class InitCommentState extends CommentState {}

class SendingCommentState extends CommentState {}

class ErrorCommentState extends CommentState {
  final String message;

  ErrorCommentState({required this.message});
}

class SuccessCommentState extends CommentState {
  final List<PostComment> comments;

  SuccessCommentState({required this.comments});
}