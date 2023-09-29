import 'package:flutter/cupertino.dart';
import 'package:qadriyatlar_app/data/models/course/courses_response.dart';

class RecentViewedService extends ChangeNotifier {
  List<CoursesBean?> _recentViewed = [];

  List<CoursesBean?> get recentViewed => _recentViewed;

  void addRecentViewed(CoursesBean? coursesBean) {
    _recentViewed.add(coursesBean);

    notifyListeners();
  }

  void clearRecentViewed() {
    _recentViewed.clear();

    notifyListeners();
  }
}
