import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:qadriyatlar_app/core/constants/preferences_name.dart';
import 'package:qadriyatlar_app/core/env.dart';
import 'package:qadriyatlar_app/core/utils/logger.dart';
import 'package:qadriyatlar_app/data/models/questions/questions_response.dart';
import 'package:qadriyatlar_app/data/repository/questions_repository.dart';

part 'questions_event.dart';

part 'questions_state.dart';

class QuestionsBloc extends Bloc<QuestionsEvent, QuestionsState> {
  QuestionsBloc() : super(InitialQuestionsState()) {
    on<LoadQuestionsEvent>((event, emit) async {
      try {
        final currentUserId = preferences.getString(PreferencesName.apiToken)!.split('|');

        QuestionsResponse questions = await _questionsRepository.getQuestions(
          event.lessonId,
          event.page,
          event.search,
          '',
        );

        QuestionsResponse questionsMy = await _questionsRepository.getQuestions(
          event.lessonId,
          event.page,
          event.search,
          currentUserId[0],
        );

        emit(LoadedQuestionsState(questions, questionsMy));
      } catch (e) {
        logger.e('Error completeLesson', e);
      }
    });
  }

  final QuestionsRepository _questionsRepository = QuestionsRepositoryImpl();
}
