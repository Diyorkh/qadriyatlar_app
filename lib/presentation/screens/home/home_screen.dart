import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qadriyatlar_app/data/models/app_settings/app_settings.dart';
import 'package:qadriyatlar_app/presentation/bloc/home/home_bloc.dart';
import 'package:qadriyatlar_app/presentation/screens/home/items/categories_item.dart';
import 'package:qadriyatlar_app/presentation/screens/home/items/new_courses_item.dart';
import 'package:qadriyatlar_app/presentation/screens/home/items/top_instructors.dart';
import 'package:qadriyatlar_app/presentation/screens/home/items/trending_item.dart';
import 'package:qadriyatlar_app/presentation/screens/home/widgets/app_bar_sliver.dart';
import 'package:qadriyatlar_app/presentation/widgets/error_widget.dart';
import 'package:qadriyatlar_app/presentation/widgets/loader_widget.dart';
import 'package:qadriyatlar_app/theme/app_color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen() : super();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHomeEvent()),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is InitialHomeState) {
                return LoaderWidget(
                  loaderColor: ColorApp.mainColor,
                );
              }

              if (state is LoadedHomeState) {
                return CustomScrollView(
                  slivers: [
                    SliverPersistentHeader(
                      delegate: SliverAppBarDelegate(),
                    ),
                    SliverToBoxAdapter(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        primary: false,
                        itemCount: state.layout.length,
                        itemBuilder: (context, index) {
                          HomeLayoutBean? item = state.layout[index];

                          switch (item?.id) {
                            case 1:
                              return CategoriesWidget(item?.name, state.categoryList);
                            case 2:
                              return NewCoursesWidget(item?.name, state.coursesNew);
                            case 3:
                              return TrendingWidget(true, item?.name, state.coursesTrending);
                            case 4:
                              return TopInstructorsWidget(item?.name, state.instructors);
                            case 5:
                              return TrendingWidget(false, item?.name, state.coursesFree);
                            default:
                              return NewCoursesWidget(item?.name, state.coursesNew);
                          }
                        },
                      ),
                    ),
                  ],
                );
              }

              if (state is ErrorHomeState) {
                return ErrorCustomWidget(
                  onTap: () => BlocProvider.of<HomeBloc>(context).add(LoadHomeEvent()),
                );
              }

              return ErrorCustomWidget(
                onTap: () => BlocProvider.of<HomeBloc>(context).add(LoadHomeEvent()),
              );
            },
          ),
        ),
      ),
    );
  }
}
