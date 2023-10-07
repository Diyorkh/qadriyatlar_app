part of 'phone_restore_password_bloc.dart';

abstract class PhoneRestorePasswordState {}

class InitialPhoneRestorePasswordState extends PhoneRestorePasswordState {}

// States of request change password
class LoadingPhoneRestorePasswordState extends PhoneRestorePasswordState {}

class SuccessPhoneRestorePasswordState extends PhoneRestorePasswordState {
  SuccessPhoneRestorePasswordState(this.message);

  final String? message;
}

class ErrorPhoneRestorePasswordState extends PhoneRestorePasswordState {
  ErrorPhoneRestorePasswordState(this.message);

  final String? message;
}

// States of change password

class LoadingChangePasswordState extends PhoneRestorePasswordState {}

class SuccessChangePasswordState extends PhoneRestorePasswordState {
  SuccessChangePasswordState(this.message);

  final String message;
}

class ErrorChangePasswordState extends PhoneRestorePasswordState {
  ErrorChangePasswordState(this.message);

  final String? message;
}
