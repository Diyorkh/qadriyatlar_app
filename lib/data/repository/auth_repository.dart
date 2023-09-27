import 'package:dio/dio.dart';
import 'package:qadriyatlar_app/core/cache/cache_manager.dart';
import 'package:qadriyatlar_app/core/constants/preferences_name.dart';
import 'package:qadriyatlar_app/core/env.dart';
import 'package:qadriyatlar_app/data/datasources/auth_datasource.dart';
import 'package:qadriyatlar_app/data/models/auth_error/auth_error.dart';
import 'package:qadriyatlar_app/data/models/change_password/change_password.dart';
import 'package:qadriyatlar_app/data/models/restore_password/restore_password.dart';

abstract class AuthRepository {
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

  Future authSocialsUser(String providerType, String? idToken, String accessToken);

  Future<ChangePasswordResponse> changePassword(String oldPassword, String newPassword);

  Future<String> demoAuth();

  Future<String> getToken();

  Future<bool> isSigned();

  Future logout();
}

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource _authDataSource = AuthDataSourceImpl();

  @override
  Future<AuthPhoneResponse> authPhone({required String phone}) async {
    AuthPhoneResponse response = await _authDataSource.authPhone(phone: phone);

    return response;
  }

  @override
  Future<AuthPhoneResponse> verifyPhone({required String phone, required String code}) async {
    AuthPhoneResponse response = await _authDataSource.verifyPhone(phone: phone, code: code);

    return response;
  }

  @override
  Future<AuthPhoneResponse> loginAccount({
    required String phone,
    required String password,
    required bool register,
    String? rePassword,
  }) async {
    AuthPhoneResponse response = await _authDataSource.loginAccount(
      phone: phone,
      password: password,
      register: register,
      rePassword: rePassword,
    );

    if (response.token != null && response.token!.isNotEmpty) {
      _saveToken(response.token!);
    }

    return response;
  }

  @override
  Future<AuthPhoneResponse> registerAccount({
    required String phone,
    required String password,
    required String name,
  }) async {
    AuthPhoneResponse response = await _authDataSource.registerAccount(
      phone: phone,
      password: password,
      name: name,
    );

    if (response.token != null && response.token!.isNotEmpty) {
      _saveToken(response.token!);
    }

    return response;
  }

  @override
  Future<RestorePasswordResponse> restorePassword(String email) async {
    final restorePasswordResponse = await _authDataSource.restorePassword(email);

    return restorePasswordResponse;
  }

  @override
  Future<ChangePasswordResponse> changePassword(String oldPassword, String newPassword) async {
    return await _authDataSource.changePassword(oldPassword, newPassword);
  }

  @override
  Future authSocialsUser(String providerType, String? idToken, String accessToken) async {
    try {
      var response = await _authDataSource.authSocialsUser(providerType, idToken!, accessToken);
      _saveToken(response['token']);
      return response;
    } on DioException catch (e) {
      return Exception(e);
    }
  }

  @override
  Future<String> getToken() {
    return Future.value(preferences.getString(PreferencesName.apiToken));
  }

  void _saveToken(String token) {
    preferences.setString(PreferencesName.apiToken, token);
  }

  @override
  Future<bool> isSigned() {
    String? token = preferences.getString(PreferencesName.apiToken);
    if (token == null) {
      return Future.value(false);
    }
    if (token.isNotEmpty) return Future.value(true);
    return Future.value(false);
  }

  @override
  Future logout() async {
    preferences.remove(PreferencesName.apiToken);
    preferences.remove(PreferencesName.demoMode);
    preferences.remove(PreferencesName.appLogo);
    await CacheManager().cleanCache();
  }

  @override
  Future<String> demoAuth() async {
    final token = await _authDataSource.demoAuth();

    _saveToken(token);

    return token;
  }
}
