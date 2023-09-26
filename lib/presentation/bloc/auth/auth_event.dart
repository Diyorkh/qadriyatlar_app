part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthPhoneEvent extends AuthEvent {
  AuthPhoneEvent(this.phone);

  final String phone;
}

class VerifyPhoneEvent extends AuthEvent {
  VerifyPhoneEvent({required this.phone, required this.code});

  final String phone;
  final String code;
}

class LoginAccountEvent extends AuthEvent {
  LoginAccountEvent({
    required this.phone,
    required this.password,
    required this.register,
    this.rePassword,
  });

  final String phone;
  final String password;
  final String? rePassword;
  final bool register;
}

class AuthSocialsEvent extends AuthEvent {
  AuthSocialsEvent({
    required this.providerType,
    this.idToken,
    required this.accessToken,
    this.photoUrl,
  });

  final String providerType;
  final String? idToken;
  final String accessToken;
  final File? photoUrl;
}

class CloseDialogEvent extends AuthEvent {}

class DemoAuthEvent extends AuthEvent {}
