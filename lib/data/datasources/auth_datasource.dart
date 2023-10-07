import 'package:dio/dio.dart';
import 'package:qadriyatlar_app/core/errors/auth_error.dart';
import 'package:qadriyatlar_app/core/services/http_service.dart';
import 'package:qadriyatlar_app/data/models/auth_error/auth_error.dart';
import 'package:qadriyatlar_app/data/models/change_password/change_password.dart';
import 'package:qadriyatlar_app/data/models/restore_password/phone_restore_password.dart';
import 'package:qadriyatlar_app/data/models/restore_password/restore_password.dart';

abstract class AuthDataSource {
  Future<AuthPhoneResponse> authPhone({required String phone});

  Future<AuthPhoneResponse> verifyPhone({required String phone, required String code});

  Future<AuthPhoneResponse> loginAccount({
    required String phone,
    required String password,
    required bool register,
    String? rePassword,
  });

  Future<AuthPhoneResponse> registerAccount({
    required String phone,
    required String password,
    required String name,
  });

  Future<RestorePasswordResponse> restorePassword(String email);

  Future<PhoneRestorePasswordResponse> phoneRestorePassword(String phone);

  Future<PhoneRestorePasswordResponse> changePasswordByPhone(String phone, String password, String passwordRe);

  Future<ChangePasswordResponse> changePassword(String oldPassword, String newPassword);

  Future authSocialsUser(String providerType, String? idToken, String accessToken);

  Future<String> demoAuth();
}

class AuthDataSourceImpl implements AuthDataSource {
  final HttpService _httpService = HttpService();

  @override
  Future<AuthPhoneResponse> authPhone({required String phone}) async {
    try {
      Response response = await _httpService.dio.post(
        '/login/otp',
        queryParameters: {
          'phone': phone,
        },
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return AuthPhoneResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<AuthPhoneResponse> verifyPhone({required String phone, required String code}) async {
    try {
      Response response = await _httpService.dio.post(
        '/login/otp/verify',
        queryParameters: {
          'phone': phone,
          'code': code,
        },
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return AuthPhoneResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<AuthPhoneResponse> loginAccount({
    required String phone,
    required String password,
    required bool register,
    String? rePassword,
  }) async {
    Map<String, dynamic> queryParams = {};

    if (rePassword != null && rePassword.isNotEmpty) {
      queryParams = {
        'phone': phone,
        'password': password,
        'register': register,
        'password_re': rePassword,
      };
    } else {
      queryParams = {
        'phone': phone,
        'password': password,
        'register': register,
      };
    }

    try {
      Response response = await _httpService.dio.post(
        '/login/account',
        queryParameters: queryParams,
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return AuthPhoneResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<RestorePasswordResponse> restorePassword(String email) async {
    try {
      Response response = await _httpService.dio.post(
        '/account/restore_password',
        data: {'email': email},
      );
      return RestorePasswordResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw AuthError(AuthErrorResponse.fromJson(e.response!.data));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future authSocialsUser(String providerType, String? idToken, String accessToken) async {
    var params = {
      'provider': providerType,
      'id_token': idToken,
      'access_token': accessToken,
    };

    try {
      Response response = await _httpService.dio.post(
        '/login/socials',
        queryParameters: params,
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<String> demoAuth() async {
    try {
      Response response = await _httpService.dio.get('/demo');

      return response.data['token'];
    } on DioException catch (e) {
      throw AuthError(AuthErrorResponse.fromJson(e.response!.data));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<ChangePasswordResponse> changePassword(String oldPassword, String newPassword) async {
    try {
      Response response = await _httpService.dio.post(
        '/account/edit_profile',
        queryParameters: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
        options: Options(
          headers: {'requirestoken': 'true'},
        ),
      );

      return ChangePasswordResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<AuthPhoneResponse> registerAccount({
    required String phone,
    required String password,
    required String name,
  }) async {
    Map<String, dynamic> queryParams = {
      'phone': phone,
      'password': password,
      'name': name,
      'register': true,
      'password_re': password,
    };

    try {
      Response response = await _httpService.dio.post(
        '/login/account',
        queryParameters: queryParams,
      );

      return AuthPhoneResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<PhoneRestorePasswordResponse> phoneRestorePassword(String phone) async {
    try {
      Response response = await _httpService.dio.post(
        '/lost-password',
        data: {
          'phone': phone,
        },
      );

      return PhoneRestorePasswordResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<PhoneRestorePasswordResponse> changePasswordByPhone(String phone, String password, String passwordRe) async {
    try {
      Response response = await _httpService.dio.post(
        '/reset-password',
        data: {
          'phone': phone,
          'password': password,
          'password_re': passwordRe,
        },
      );

      return PhoneRestorePasswordResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
