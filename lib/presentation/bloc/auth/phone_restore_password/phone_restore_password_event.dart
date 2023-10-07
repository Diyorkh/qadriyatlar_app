part of 'phone_restore_password_bloc.dart';

abstract class PhoneRestorePasswordEvent {}

class RequestPasswordRestoreEvent extends PhoneRestorePasswordEvent {
  RequestPasswordRestoreEvent({required this.phone});

  final String phone;
}

class ChangePasswordByPhoneEvent extends PhoneRestorePasswordEvent {
  ChangePasswordByPhoneEvent({required this.phone, required this.password, required this.passwordRe});

  final String phone;
  final String password;
  final String passwordRe;
}
