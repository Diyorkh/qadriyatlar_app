import 'dart:convert';
import 'package:qadriyatlar_app/core/constants/preferences_name.dart';
import 'package:qadriyatlar_app/core/env.dart';
import 'package:qadriyatlar_app/data/models/user_course/user_course.dart';

class ProgressCoursesLocalStorage {
  List<UserCourseResponse> getUserCoursesLocal() {
    try {
      List<String>? cached = preferences.getStringList(PreferencesName.userCourses);
      cached ??= [];

      return cached.map((json) => UserCourseResponse.fromJson(jsonDecode(json))).toList();
    } catch (e) {
      throw Exception();
    }
  }

  void saveProgressCourses(UserCourseResponse userCourseResponse) {
    String json = jsonEncode(userCourseResponse.toJson());

    List<String>? cached = preferences.getStringList(PreferencesName.userCourses);

    cached ??= [];

    cached = [];
    cached.add(json);

    preferences.setStringList(PreferencesName.userCourses, cached);
  }
}
