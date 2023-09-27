import 'package:json_annotation/json_annotation.dart';

part 'auth_error.g.dart';

@JsonSerializable()
class AuthErrorResponse {
  AuthErrorResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory AuthErrorResponse.fromJson(Map<String, dynamic> json) => _$AuthErrorResponseFromJson(json);

  final String? code;
  final String? message;
  final ErrorData? data;

  Map<String, dynamic> toJson() => _$AuthErrorResponseToJson(this);
}

@JsonSerializable()
class ErrorData {
  ErrorData({this.status, this.params});

  factory ErrorData.fromJson(Map<String, dynamic> json) => _$ErrorDataFromJson(json);

  final int? status;
  final List<String?>? params;

  Map<String, dynamic> toJson() => _$ErrorDataToJson(this);
}

@JsonSerializable()
class AuthPhoneResponse {
  AuthPhoneResponse({
    required this.message,
    required this.status,
    this.token,
  });

  factory AuthPhoneResponse.fromJson(Map<String, dynamic> json) => _$AuthPhoneResponseFromJson(json);

  final String message;
  final AuthPhoneStatus status;
  final String? token;

  Map<String, dynamic> toJson() => _$AuthPhoneResponseToJson(this);
}

enum AuthPhoneStatus { password, verify, error, limit }
