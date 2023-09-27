import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qadriyatlar_app/core/env.dart';
import 'package:qadriyatlar_app/data/models/category/category.dart';
import 'package:qadriyatlar_app/data/models/course/courses_response.dart';
import 'package:qadriyatlar_app/main.dart';
import 'package:qadriyatlar_app/presentation/screens/category_detail/category_detail_screen.dart';
import 'package:qadriyatlar_app/presentation/screens/course_detail/course_detail_screen.dart';
import 'package:qadriyatlar_app/theme/app_color.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class NewCoursesWidget extends StatelessWidget {
  NewCoursesWidget(this.title, this.courses, {Key? key}) : super(key: key);

  final String? title;
  final List<CoursesBean?> courses;

  @override
  Widget build(BuildContext context) {
    return courses.length != 0
        ? SizedBox(
            height: 370.0,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 20.0, bottom: 10),
                  child: Text(
                    localizations.getLocalization('new_courses'),
                    textScaleFactor: 1.0,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Color(0xFFeef1f7)),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: courses.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 1.3,
                      ),
                      padding: EdgeInsets.only(left: 5),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = courses[index];

                        double? rating = 0.0;
                        num? reviews = 0;
                        rating = item?.rating?.average?.toDouble();
                        reviews = item?.rating?.total;

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              CourseScreen.routeName,
                              arguments: CourseScreenArgs.fromCourseBean(item),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CourseCard(
                              image: item?.images?.small,
                              category: item!.categoriesObject.isNotEmpty ? item.categoriesObject.first : null,
                              title: item.title,
                              stars: rating,
                              reviews: reviews,
                              price: item.price?.price,
                              oldPrice: item.price?.oldPrice,
                              free: item.price?.free,
                              status: item.status,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        : SizedBox();
  }
}

class CourseCard extends StatelessWidget {
  const CourseCard({
    Key? key,
    required this.image,
    this.category,
    required this.title,
    required this.stars,
    required this.reviews,
    required this.price,
    required this.oldPrice,
    required this.free,
    this.status,
  }) : super(key: key);

  final String? image;
  final Category? category;
  final String? title;
  final double? stars;
  final num? reviews;
  final String? price;
  final String? oldPrice;
  final bool? free;
  final StatusBean? status;

  String get categoryName =>
      category != null && category!.name.isNotEmpty ? '${unescape.convert(category!.name)} >' : '';

  @override
  Widget build(BuildContext context) {
    Widget buildPrice;

    if (free!) {
      buildPrice = Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
        child: Text(
          localizations.getLocalization('course_free_price'),
          textScaleFactor: 1.0,
          style: Theme.of(context).primaryTextTheme.headlineSmall?.copyWith(
                color: ColorApp.dark,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
              ),
        ),
      );
    } else {
      buildPrice = Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
          child: Row(
            children: <Widget>[
              Text(
                price!,
                textScaleFactor: 1.0,
                style: const TextStyle(
                  color: ColorApp.dark,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              Visibility(
                visible: oldPrice != null,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    oldPrice.toString(),
                    textScaleFactor: 1.0,
                    style: Theme.of(context).primaryTextTheme.headlineSmall?.copyWith(
                          color: Color(0xFF999999),
                          fontStyle: FontStyle.normal,
                          fontSize: 17.0,
                          decoration: TextDecoration.lineThrough,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ZoomTapAnimation(
      onTap: () {},
      child: Card(
        color: const Color.fromRGBO(243, 243, 248, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.0),
                    topLeft: Radius.circular(12.0),
                  ),
                  child: Image.network(
                    image!,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (status != null)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: ColorApp.secondaryColor,
                      ),
                      child: Text(
                        status?.label ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 11.0, left: 8.0, right: 8.0, bottom: 5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    CategoryDetailScreen.routeName,
                    arguments: CategoryDetailScreenArgs(category),
                  );
                },
                child: Text(
                  categoryName,
                  textScaleFactor: 1.0,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0, left: 8.0, right: 8.0),
              child: Text(
                unescape.convert(title ?? ''),
                textScaleFactor: 1.0,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Divider(
                color: Color(0xFFe0e0e0),
                thickness: 1.3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      '${stars} (${reviews})',
                      textScaleFactor: 1.0,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 20,
                  ),
                ],
              ),
            ),
            const Spacer(),
            buildPrice,
          ],
        ),
      ),
    );
  }
}
