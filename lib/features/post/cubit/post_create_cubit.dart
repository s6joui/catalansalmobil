import 'package:catalansalmon_flutter/features/auth/data/auth_repository.dart';
import 'package:catalansalmon_flutter/features/post/cubit/post_create_state.dart';
import 'package:catalansalmon_flutter/features/post/data/posts_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCreateCubit extends Cubit<PostCreateState> {

  final PostsRepository _repo;
  final AuthRepository _authRepository;

  final String communityId;
  final String postId;

  PostCreateCubit(this._authRepository, this._repo, this.communityId, this.postId) : super(InitPostCreateState());

  Future<void> createComment(String comment) async {
    emit(SendingPostCreateState());
    try {
      if (_authRepository.token == null) {
        throw Exception('Not authenticated');
      }
      final comments = await _repo.createComment(_authRepository.token!, communityId, postId, comment);
      emit(SuccessPostCreateState(
          comments: comments));
    } catch (error) {
      emit(ErrorPostCreateState(message: error.toString()));
    }
  }
}