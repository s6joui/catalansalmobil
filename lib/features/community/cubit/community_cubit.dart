import 'package:catalansalmon_flutter/data/community_repo.dart';
import 'package:catalansalmon_flutter/features/auth/data/auth_repository.dart';
import 'package:catalansalmon_flutter/features/community/cubit/community_state.dart';
import 'package:catalansalmon_flutter/features/community/model/community_details.dart';
import 'package:catalansalmon_flutter/model/community.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommunityCubit extends Cubit<CommunityState> {
  final CommunityRepository _communityRepository;
  final Community _community;

  final AuthRepository _authRepository;

  CommunityCubit(
      this._community, this._communityRepository, this._authRepository)
      : super(InitCommunityState());

  Future<void> fetchContent(CommunityDetails? details, {bool bypassCache = false}) async {
    emit(LoadingCommunityState());
    try {
      final posts = await _communityRepository.getCommunityPosts(_community.id, bypassCache);
      if (details == null) {
        final details = await _communityRepository.getCommunityDetails(_community.id);
        emit(ResponseCommunityState(_community, details, posts, _authRepository.isLoggedIn()));
      } else {
        emit(ResponseCommunityState(_community, details, posts, _authRepository.isLoggedIn()));
      }
    } catch (error) {
      emit(ErrorCommunityState(message: error.toString()));
    }
  }

  Future<void> logout() async {
    _authRepository.clearData();
    checkAuthChange();
  }

  Future<void> checkAuthChange() async {
    if (state is! ResponseCommunityState) {
      return;
    }
    final responseState = state as ResponseCommunityState;
    emit(responseState.copyWith(isLoggedIn: _authRepository.isLoggedIn()));
  }
}
