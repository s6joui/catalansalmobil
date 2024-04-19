abstract class AuthState {}

class InitAuthState extends AuthState {}

class LoadingAuthState extends AuthState {}

class ErrorAuthState extends AuthState {
  final String message;

  ErrorAuthState({required this.message});
}

class LoginSuccessAuthState extends AuthState {}

class LogoutAuthState extends AuthState {}
