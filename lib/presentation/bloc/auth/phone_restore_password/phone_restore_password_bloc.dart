import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qadriyatlar_app/core/utils/logger.dart';
import 'package:qadriyatlar_app/data/models/restore_password/phone_restore_password.dart';
import 'package:qadriyatlar_app/data/repository/auth_repository.dart';

part 'phone_restore_password_event.dart';

part 'phone_restore_password_state.dart';

class PhoneRestorePasswordBloc extends Bloc<PhoneRestorePasswordEvent, PhoneRestorePasswordState> {
  PhoneRestorePasswordBloc() : super(InitialPhoneRestorePasswordState()) {
    on<RequestPasswordRestoreEvent>((event, emit) async {
      emit(LoadingPhoneRestorePasswordState());
      try {
        final response = await _authRepository.phoneRestorePassword(event.phone);

        if (response.status == PhoneRestorePasswordStatus.error) {
          emit(ErrorPhoneRestorePasswordState(response.message));
        } else if (response.status == PhoneRestorePasswordStatus.success) {
          emit(SuccessPhoneRestorePasswordState(response.message));
        }
      } catch (e, s) {
        logger.e('Error signUp', e, s);
        emit(ErrorPhoneRestorePasswordState(e.toString()));
      }
    });

    on<ChangePasswordByPhoneEvent>((event, emit) async {
      emit(LoadingChangePasswordState());
      try {
        final response = await _authRepository.changePasswordByPhone(
          event.phone,
          event.password,
          event.passwordRe,
        );

        if (response.status == PhoneRestorePasswordStatus.error) {
          emit(ErrorChangePasswordState(response.message));
        } else if (response.status == PhoneRestorePasswordStatus.success) {
          emit(SuccessChangePasswordState(response.message ?? 'Password changed successfully'));
        }
      } catch (e, s) {
        logger.e('Error with change password by phone', e, s);
        emit(ErrorChangePasswordState(e.toString()));
      }
    });
  }

  final AuthRepository _authRepository = AuthRepositoryImpl();
}
