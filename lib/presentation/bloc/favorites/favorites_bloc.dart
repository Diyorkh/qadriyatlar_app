import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:qadriyatlar_app/core/utils/logger.dart';
import 'package:qadriyatlar_app/core/utils/utils.dart';
import 'package:qadriyatlar_app/data/models/course/courses_response.dart';
import 'package:qadriyatlar_app/data/repository/courses_repository.dart';

part 'favorites_event.dart';

part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(InitialFavoritesState()) {
    on<FetchFavorites>((event, emit) async {
      emit(InitialFavoritesState());

      if (!isAuth()) {
        emit(UnauthorizedState());
        return;
      }

      try {
        final courses = await _coursesRepository.getFavoriteCourses();

        if (courses.courses.isNotEmpty) {
          emit(LoadedFavoritesState(courses.courses));
        } else {
          emit(EmptyFavoritesState());
        }
      } catch (e, s) {
        logger.e('Error getFavoriteCourses', e, s);
        emit(ErrorFavoritesState(e.toString()));
      }
    });

    on<DeleteEvent>((event, emit) async {
      try {
        final courses = (state as LoadedFavoritesState).favoriteCourses;

        courses.removeWhere((item) => item?.id == event.courseId);

        await _coursesRepository.deleteFavoriteCourse(event.courseId);

        emit(SuccessDeleteFavoriteCourseState());
      } catch (e, s) {
        logger.e('Error deleteFavorite', e, s);
      }
    });
  }

  final CoursesRepository _coursesRepository = CoursesRepositoryImpl();
}
