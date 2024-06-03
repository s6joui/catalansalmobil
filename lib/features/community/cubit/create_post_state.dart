abstract class CreatePostState {}

class InitCreatePostState extends CreatePostState {}

class SendingCreatePostState extends CreatePostState {}

class ErrorCreatePostState extends CreatePostState {
  final String message;

  ErrorCreatePostState({required this.message});
}

class SuccessCreatePostState extends CreatePostState {}
