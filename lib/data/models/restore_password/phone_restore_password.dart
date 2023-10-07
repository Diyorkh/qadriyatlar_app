import 'package:json_annotation/json_annotation.dart';

part 'phone_restore_password.g.dart';

@JsonSerializable()
class PhoneRestorePasswordResponse {
  PhoneRestorePasswordResponse({required this.message, required this.status});

  factory PhoneRestorePasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$PhoneRestorePasswordResponseFromJson(json);

  final String? message;
  final PhoneRestorePasswordStatus status;

  Map<String, dynamic> toJson() => _$PhoneRestorePasswordResponseToJson(this);
}

enum PhoneRestorePasswordStatus { success, error }
