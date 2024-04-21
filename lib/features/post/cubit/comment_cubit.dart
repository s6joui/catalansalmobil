import 'package:catalansalmon_flutter/data/community_repo.dart';
import 'package:catalansalmon_flutter/features/auth/data/auth_repository.dart';
import 'package:catalansalmon_flutter/features/post/cubit/comment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentCubit extends Cubit<CommentState> {

  final CommunityRepository _repo;
  final AuthRepository _authRepository;

  final String communityId;
  final String postId;

  CommentCubit(this._authRepository, this._repo, this.communityId, this.postId) : super(InitCommentState());

  Future<void> createComment(String comment) async {
    emit(SendingCommentState());
    try {
      if (_authRepository.token == null) {
        throw Exception('Not authenticated');
      }
      final comments = await _repo.createComment(_authRepository.token!, communityId, postId, comment);
      emit(SuccessCommentState(
          comments: comments));
    } catch (error) {
      emit(ErrorCommentState(message: error.toString()));
    }
  }
}