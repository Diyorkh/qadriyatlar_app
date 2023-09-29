import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qadriyatlar_app/presentation/screens/course_detail/course_detail_screen.dart';
import 'package:qadriyatlar_app/presentation/screens/search/components/recent_viewed_service.dart';
import 'package:qadriyatlar_app/theme/app_color.dart';

class RecentCourses extends StatefulWidget {
  const RecentCourses({super.key});

  @override
  State<RecentCourses> createState() => _RecentCoursesState();
}

class _RecentCoursesState extends State<RecentCourses> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (Provider.of<RecentViewedService>(context).recentViewed.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // TODO: 29.09.2023 Add translations
                Text(
                  'Recently Viewed',
                  textScaleFactor: 1.0,
                  style: Theme.of(context).primaryTextTheme.headlineSmall?.copyWith(
                        color: ColorApp.dark,
                        fontStyle: FontStyle.normal,
                      ),
                ),
                // TODO: 29.09.2023 Add translations
                InkWell(
                  onTap: () => Provider.of<RecentViewedService>(context, listen: false).clearRecentViewed(),
                  child: Text(
                    'CLEAR',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: Provider.of<RecentViewedService>(context).recentViewed.length,
          itemBuilder: (BuildContext context, int index) {
            final item = Provider.of<RecentViewedService>(context).recentViewed[index];
            return ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  CourseScreen.routeName,
                  arguments: CourseScreenArgs.fromCourseBean(item),
                );
              },
              leading: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: Image.network(
                  item!.images!.small!,
                  width: 60,
                ),
              ),
              title: Text(
                item.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.lato(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
              subtitle: Text(
                item.categories.isNotEmpty ? item.categories.first ?? '' : 'No categories',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
