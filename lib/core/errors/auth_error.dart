import 'package:qadriyatlar_app/data/models/auth_error/auth_error.dart';

class AuthError implements Exception {
  AuthError(this.authErrorResponse);

  final AuthErrorResponse authErrorResponse;
}
