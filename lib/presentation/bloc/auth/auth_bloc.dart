import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:qadriyatlar_app/core/constants/preferences_name.dart';
import 'package:qadriyatlar_app/core/env.dart';
import 'package:qadriyatlar_app/core/errors/auth_error.dart';
import 'package:qadriyatlar_app/core/utils/logger.dart';
import 'package:qadriyatlar_app/data/models/auth_error/auth_error.dart';
import 'package:qadriyatlar_app/data/repository/auth_repository.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(InitialAuthState()) {
    on<AuthPhoneEvent>((event, emit) async {
      emit(LoadingAuthPhoneState());
      try {
        final response = await _repository.authPhone(phone: event.phone);

        if (response.status == AuthPhoneStatus.password) {
          emit(AuthPasswordState(response.message));
        } else if (response.status == AuthPhoneStatus.verify) {
          emit(AuthVerifyPhoneState(response.message));
        }
      } on AuthError catch (e, s) {
        logger.e('Error signUp from API', e, s);
        emit(ErrorAuthPhoneState(e.authErrorResponse.message ?? 'Unknown Error'));
      } catch (e, s) {
        logger.e('Error signUp', e, s);
        emit(ErrorAuthPhoneState(e.toString()));
      }
    });

    on<VerifyPhoneEvent>((event, emit) async {
      emit(LoadingVerifyPhoneState());
      try {
        final response = await _repository.verifyPhone(
          phone: event.phone,
          code: event.code,
        );

        if (response.status == AuthPhoneStatus.error) {
          emit(InvalidVerifyCodeState(response.message));
        } else if (response.status == AuthPhoneStatus.password) {
          emit(SuccessVerifyPhoneState(response.message));
        } else {
          emit(ErrorVerifyPhoneState('Unknown Error'));
        }
      } on AuthError catch (e, s) {
        logger.e('Error verifyPhone from API', e, s);
        emit(ErrorVerifyPhoneState(e.authErrorResponse.message ?? 'Unknown Error'));
      } catch (e, s) {
        logger.e('Error verifyPhone', e, s);
        emit(ErrorVerifyPhoneState(e.toString()));
      }
    });

    on<LoginAccountEvent>((event, emit) async {
      emit(LoadingLoginAccountState());
      try {
        final response = await _repository.loginAccount(
          phone: event.phone,
          password: event.password,
          register: event.register,
          rePassword: event.rePassword,
        );
        if (response.status == AuthPhoneStatus.error) {
          emit(ErrorLoginAccountState(response.message));
        } else {
          emit(SuccessLoginAccountState());
        }
      } on AuthError catch (e, s) {
        logger.e('Error signUp from API', e, s);
        emit(ErrorLoginAccountState(e.authErrorResponse.message ?? 'Unknown Error'));
      } catch (e, s) {
        logger.e('Error signUp', e, s);
        emit(ErrorLoginAccountState(e.toString()));
      }
    });

    on<DemoAuthEvent>((event, emit) async {
      emit(LoadingDemoAuthState());
      try {
        preferences.setBool(PreferencesName.demoMode, true);
        await _repository.demoAuth();
        emit(SuccessDemoAuthState());
      } on AuthError catch (e, s) {
        logger.e('Error calling demoAuth()', e, s);
        preferences.remove(PreferencesName.demoMode);
        emit(ErrorDemoAuthState(e.authErrorResponse.message ?? 'Unknown Error'));
      } catch (e, s) {
        logger.e('Error demoAuth', e, s);
        preferences.remove(PreferencesName.demoMode);
        var errorData = json.decode(e.toString());
        emit(ErrorDemoAuthState(errorData['message']));
      }
    });

    on<AuthSocialsEvent>((event, emit) async {
      if (event.providerType == 'google') {
        emit(LoadingAuthGoogleState());
      } else {
        emit(LoadingAuthFacebookState());
      }

      try {
        await _repository.authSocialsUser(
          event.providerType,
          event.idToken ?? '',
          event.accessToken,
        );

        emit(SuccessAuthSocialsState(event.photoUrl));
      } catch (e, s) {
        logger.e('Error authSocialsUser', e, s);
        emit(ErrorAuthSocialsState(e.toString()));
      }
    });
  }

  final AuthRepository _repository = AuthRepositoryImpl();
}
