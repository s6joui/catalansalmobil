// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:catalansalmon_flutter/features/auth/data/auth_repository.dart';
import 'package:catalansalmon_flutter/features/post/model/post_comment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:catalansalmon_flutter/data/community_repo.dart';
import 'package:catalansalmon_flutter/features/community/model/community_post.dart';
import 'package:catalansalmon_flutter/features/post/cubit/post_state.dart';

class PostCubit extends Cubit<PostState> {
  final CommunityRepository _communityRepository;
  final AuthRepository _authRepository;
  final String _communityId;
  final CommunityPost _post;

  PostCubit(
    this._authRepository,
    this._communityRepository,
    this._communityId,
    this._post,
  ) : super(InitPostState());

  Future<void> fetchComments() async {
    emit(LoadingPostState());
    try {
      final comments =
          await _communityRepository.getPostComments(_communityId, _post.id);
      emit(ResponsePostState(
          comments: comments, isLoggedIn: _authRepository.isLoggedIn()));
    } catch (error) {
      emit(ErrorPostState(message: error.toString()));
    }
  }

  void checkAuthChange() {
    if (state is! ResponsePostState) {
      return;
    }
    final responseState = state as ResponsePostState;
    emit(responseState.copyWith(isLoggedIn: _authRepository.isLoggedIn()));
  }

  void updateCommentList(List<PostComment> comments) {
    emit(ResponsePostState(
          comments: comments, isLoggedIn: _authRepository.isLoggedIn()));
  }
}
