import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:qadriyatlar_app/core/utils/logger.dart';
import 'package:qadriyatlar_app/data/models/category/category.dart';
import 'package:qadriyatlar_app/data/models/course/courses_response.dart';
import 'package:qadriyatlar_app/data/repository/courses_repository.dart';
import 'package:qadriyatlar_app/data/repository/home_repository.dart';

part 'category_detail_event.dart';

part 'category_detail_state.dart';

class CategoryDetailBloc extends Bloc<CategoryDetailEvent, CategoryDetailState> {
  CategoryDetailBloc() : super(InitialCategoryDetailState()) {
    on<FetchEvent>((event, emit) async {
      emit(InitialCategoryDetailState());
      try {
        final categories = await _homeRepository.getCategories();

        final courses = await _coursesRepository.getCourses(categoryId: event.categoryId);

        emit(LoadedCategoryDetailState(categories, courses.courses));
      } catch (e, s) {
        logger.e('Error getCategories/getCourses', e, s);
        emit(ErrorCategoryDetailState(event.categoryId));
      }
    });
  }

  final HomeRepository _homeRepository = HomeRepositoryImpl();
  final CoursesRepository _coursesRepository = CoursesRepositoryImpl();

  CategoryDetailState get initialState => InitialCategoryDetailState();
}
