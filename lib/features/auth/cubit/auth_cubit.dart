import 'package:catalansalmon_flutter/features/auth/cubit/auth_state.dart';
import 'package:catalansalmon_flutter/features/auth/data/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  String? _token;

  AuthCubit(this._repository) : super(InitAuthState());

  String? getToken() {
    return _token;
  }

  Future<void> performLogin(String user, String password, String communityId) async {
    emit(LoadingAuthState());
    try {
      _token = await _repository.getAuthToken(user, password, communityId);
      emit(LoginSuccessAuthState());
    } catch (error) {
      emit(ErrorAuthState(message: error.toString()));
    }
  }

  Future<void> retryLogin() async {
    emit(InitAuthState());
  }

  Future<void> logout() async {
    try {
      await _repository.clearData();
      emit(LogoutAuthState());
    } catch (error) {
      emit(ErrorAuthState(message: error.toString()));
    }
  }
}
