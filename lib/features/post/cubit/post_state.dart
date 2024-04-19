import 'package:catalansalmon_flutter/features/post/model/post_comment.dart';

abstract class PostState {}

class InitPostState extends PostState {}

class LoadingPostState extends PostState {}

class ErrorPostState extends PostState {
  final String message;

  ErrorPostState({required this.message});
}

class ResponsePostState extends PostState {
  final List<PostComment> comments;
  final bool isLoggedIn;

  ResponsePostState({required this.comments, required this.isLoggedIn});

  ResponsePostState copyWith({
    List<PostComment>? comments,
    bool? isLoggedIn,
  }) {
    return ResponsePostState(
      comments: comments ?? this.comments,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}
