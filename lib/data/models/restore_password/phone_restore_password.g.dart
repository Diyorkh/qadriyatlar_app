// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_restore_password.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhoneRestorePasswordResponse _$PhoneRestorePasswordResponseFromJson(
  Map<String, dynamic> json,
) =>
    PhoneRestorePasswordResponse(
      message: json['message'] as String?,
      status: $enumDecode(_$PhoneRestorePasswordStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$PhoneRestorePasswordResponseToJson(
  PhoneRestorePasswordResponse instance,
) =>
    <String, dynamic>{
      'message': instance.message,
      'status': _$PhoneRestorePasswordStatusEnumMap[instance.status]!,
    };

const _$PhoneRestorePasswordStatusEnumMap = {
  PhoneRestorePasswordStatus.success: 'success',
  PhoneRestorePasswordStatus.error: 'error',
};
