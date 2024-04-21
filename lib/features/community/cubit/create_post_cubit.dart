import 'package:catalansalmon_flutter/data/community_repo.dart';
import 'package:catalansalmon_flutter/features/auth/data/auth_repository.dart';
import 'package:catalansalmon_flutter/features/community/cubit/create_post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePostCubit extends Cubit<CreatePostState> {

  final CommunityRepository _repo;
  final AuthRepository _authRepository;

  final String communityId;

  CreatePostCubit(this._authRepository, this._repo, this.communityId) : super(InitCreatePostState());

  Future<void> createPost(String title, String body) async {
    emit(SendingCreatePostState());
    try {
      if (_authRepository.token == null) {
        throw Exception('Not authenticated');
      }
      final posts = await _repo.createPost(_authRepository.token!, communityId, title, body);
      emit(SuccessCreatePostState());
    } catch (error) {
      emit(ErrorCreatePostState(message: error.toString()));
    }
  }
}