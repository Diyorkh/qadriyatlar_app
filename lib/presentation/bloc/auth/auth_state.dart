part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class InitialAuthState extends AuthState {}

// Auth Phone State
class LoadingAuthPhoneState extends AuthState {}

class AuthPasswordState extends AuthState {
  AuthPasswordState(this.message);

  final String message;
}

class AuthVerifyPhoneState extends AuthState {
  AuthVerifyPhoneState(this.message);

  final String message;
}

class AuthLimitPhoneState extends AuthState {
  AuthLimitPhoneState(this.message);

  final String message;
}

class SuccessAuthPhoneState extends AuthState {}

class ErrorAuthPhoneState extends AuthState {
  ErrorAuthPhoneState(this.message);

  final String message;
}

// Verify Phone State
class LoadingVerifyPhoneState extends AuthState {}

class SuccessVerifyPhoneState extends AuthState {
  SuccessVerifyPhoneState(this.message);

  final String message;
}

class InvalidVerifyCodeState extends AuthState {
  InvalidVerifyCodeState(this.message);

  final String? message;
}

class ErrorVerifyPhoneState extends AuthState {
  ErrorVerifyPhoneState(this.message);

  final String? message;
}

// Login Account State
class LoadingLoginAccountState extends AuthState {}

class SuccessLoginAccountState extends AuthState {}

class ErrorLoginAccountState extends AuthState {
  ErrorLoginAccountState(this.message);

  final String message;
}

// Register Account State
class LoadingRegisterAccountState extends AuthState {}

class SuccessRegisterAccountState extends AuthState {}

class ErrorRegisterAccountState extends AuthState {
  ErrorRegisterAccountState(this.message);

  final String message;
}

// DemoState
class LoadingDemoAuthState extends AuthState {}

class SuccessDemoAuthState extends AuthState {}

class ErrorDemoAuthState extends AuthState {
  ErrorDemoAuthState(this.message);

  final String message;
}

// AuthSocials
class LoadingAuthGoogleState extends AuthState {}

class LoadingAuthFacebookState extends AuthState {}

class SuccessAuthSocialsState extends AuthState {
  SuccessAuthSocialsState(this.photoUrl);

  final File? photoUrl;
}

class ErrorAuthSocialsState extends AuthState {
  ErrorAuthSocialsState(this.message);

  final String message;
}
