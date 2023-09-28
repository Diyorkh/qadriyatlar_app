import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:qadriyatlar_app/core/constants/preferences_name.dart';
import 'package:qadriyatlar_app/core/env.dart';
import 'package:qadriyatlar_app/core/utils/logger.dart';
import 'package:qadriyatlar_app/core/utils/utils.dart';
import 'package:qadriyatlar_app/data/models/account/account.dart';
import 'package:qadriyatlar_app/data/repository/account_repository.dart';
import 'package:qadriyatlar_app/data/repository/auth_repository.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(InitialProfileState()) {
    on<FetchProfileEvent>((event, emit) async {
      emit(InitialProfileState());

      if (!isAuth()) {
        emit(UnauthorizedState());
        return;
      }

      try {
        Account account = await _accountRepository.getUserAccount();

        if (account.login != null && account.login!.isNotEmpty) {
          preferences.setString(PreferencesName.userName, account.login!);
        }

        _accountRepository.saveAccountLocal(account);

        emit(LoadedProfileState(account));
      } catch (e, s) {
        logger.e('Error with method getUserAccount() - /account/', e, s);
        List<Account> accountLocal = await _accountRepository.getAccountLocal();

        emit(LoadedProfileState(accountLocal.first));
      }
    });

    on<UpdateProfileEvent>((event, emit) async {
      emit(InitialProfileState());
      try {
        Account account = await _accountRepository.getUserAccount();
        emit(LoadedProfileState(account));
      } catch (e, s) {
        logger.e('Error with method getUserAccount() - /account/', e, s);
      }
    });

    on<LogoutProfileEvent>((event, emit) async {
      await _authRepository.logout();
      emit(LogoutProfileState());
    });
  }

  final AccountRepository _accountRepository = AccountRepositoryImpl();
  final AuthRepository _authRepository = AuthRepositoryImpl();
  Account? account;
}
