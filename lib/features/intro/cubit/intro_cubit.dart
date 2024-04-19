import 'dart:developer';

import 'package:catalansalmon_flutter/data/community_repo.dart';
import 'package:catalansalmon_flutter/features/auth/data/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catalansalmon_flutter/features/intro/cubit/intro_state.dart';

class IntroCubit extends Cubit<IntroState> {

  final AuthRepository _authRepository;
  final CommunityRepository _communityRepository;

  IntroCubit(this._authRepository, this._communityRepository) : super(InitIntroState());

  Future<void> startIntroFlow() async {
    await _authRepository.readCredentials();
    if (_authRepository.hasSavedCredentials()) {
      _attemptLogin();
    } else {
      fetchNearbyCommunities();
    }
  }

  Future<void> _attemptLogin() async {
    if (!_authRepository.hasSavedCredentials()) { return; }
    emit(LoadingIntroState());
    try {
      await _authRepository.loginWithSavedCredentials();
      if (_authRepository.currentCommunityId == null) {
        throw "Missing community details";
      }
      final details = await _communityRepository.getCommunityDetails(_authRepository.currentCommunityId!);
      emit(LoginSuccessIntroState(details));
    } catch (error) {
      log('Login error $error');
      fetchNearbyCommunities();
    }
  }

  Future<void> fetchNearbyCommunities() async {
    emit(LoadingIntroState());
    try {
      final response = await _communityRepository.getNearbyCommunities();
      await Future.delayed(const Duration(seconds: 1));
      emit(ResponseIntroState(nearbyCommunities: response));
    } catch (error) {
      emit(ErrorIntroState(message: error.toString()));
    }
  }
}