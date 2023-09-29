import 'package:flutter/cupertino.dart';
import 'package:qadriyatlar_app/core/constants/preferences_name.dart';
import 'package:qadriyatlar_app/core/env.dart';

class RecentSearchService extends ChangeNotifier {
  List<String> _recentSearch = preferences.getStringList(PreferencesName.recentSearches) ?? [];

  List<String> get recentSearch => _recentSearch;

  void createRecentSearches(String value) {
    _recentSearch.add(value);

    preferences.setStringList(PreferencesName.recentSearches, _recentSearch);

    _recentSearch = preferences.getStringList(PreferencesName.recentSearches) ?? [];

    notifyListeners();
  }

  void deleteRecentSearches() {
    _recentSearch.clear();

    preferences.remove(PreferencesName.recentSearches);

    notifyListeners();
  }
}
