import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:qadriyatlar_app/core/constants/assets_path.dart';
import 'package:qadriyatlar_app/main.dart';
import 'package:qadriyatlar_app/presentation/bloc/search/search_screen_bloc.dart';
import 'package:qadriyatlar_app/presentation/screens/search/widgets/popular_searches.dart';
import 'package:qadriyatlar_app/presentation/screens/search/widgets/recent_courses.dart';
import 'package:qadriyatlar_app/presentation/screens/search/widgets/recent_searches.dart';
import 'package:qadriyatlar_app/presentation/screens/search_detail/search_detail_screen.dart';
import 'package:qadriyatlar_app/presentation/widgets/course_grid_item.dart';
import 'package:qadriyatlar_app/presentation/widgets/empty_widget.dart';
import 'package:qadriyatlar_app/presentation/widgets/error_widget.dart';
import 'package:qadriyatlar_app/presentation/widgets/loader_widget.dart';
import 'package:qadriyatlar_app/theme/app_color.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) => SearchScreenWidget();
}

class SearchScreenWidget extends StatefulWidget {
  const SearchScreenWidget({super.key});

  @override
  State<StatefulWidget> createState() => SearchScreenWidgetState();
}

class SearchScreenWidgetState extends State<SearchScreenWidget> {
  @override
  void initState() {
    BlocProvider.of<SearchScreenBloc>(context).add(FetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F9),
      appBar: AppBar(
        backgroundColor: Color(0xFFF3F5F9),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0, left: 5, right: 5),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed(
                SearchDetailScreen.routeName,
                arguments: SearchDetailScreenArgs(),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                elevation: 0,
                color: Color(0xFFF3F5F9),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                localizations.getLocalization('search_bar_title'),
                                textScaleFactor: 1.0,
                                style: TextStyle(color: Colors.black.withOpacity(0.5)),
                              ),
                            ),
                            Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchScreenBloc, SearchScreenState>(
        builder: (context, state) {
          if (state is InitialSearchScreenState) {
            return LoaderWidget(
              loaderColor: ColorApp.mainColor,
            );
          }

          if (state is LoadedSearchScreenState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RecentCourses(),
                  PopularSearches(
                    popularSearch: state.popularSearch,
                  ),
                  RecentSearches(),
                  state.newCourses.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: EmptyWidget(
                            iconData: IconPath.emptyCourses,
                            title: localizations.getLocalization('courses_is_empty'),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0, left: 15.0,bottom: 10),
                              child: Text(
                                localizations.getLocalization('new_courses'),
                                textScaleFactor: 1.0,
                                style: Theme.of(context).primaryTextTheme.headlineSmall?.copyWith(
                                      color: ColorApp.dark,
                                      fontStyle: FontStyle.normal,
                                    ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              child: AlignedGridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.newCourses.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final item = state.newCourses[index];
                                  return CourseGridItem(item);
                                },
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            );
          }

          if (state is ErrorSearchScreenState) {
            return ErrorCustomWidget(
              onTap: () => BlocProvider.of<SearchScreenBloc>(context).add(FetchEvent()),
            );
          }

          return ErrorCustomWidget(
            onTap: () => BlocProvider.of<SearchScreenBloc>(context).add(FetchEvent()),
          );
        },
      ),
    );
  }
}
