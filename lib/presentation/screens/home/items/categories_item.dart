import 'package:flutter/material.dart';
import 'package:qadriyatlar_app/core/env.dart';
import 'package:qadriyatlar_app/core/extensions/color_extensions.dart';
import 'package:qadriyatlar_app/data/models/category/category.dart';
import 'package:qadriyatlar_app/presentation/screens/category_detail/category_detail_screen.dart';
import 'package:qadriyatlar_app/theme/app_color.dart';

class CategoriesWidget extends StatelessWidget {
  CategoriesWidget(
    this.title,
    this.categories, {
    Key? key,
  }) : super(key: key);

  final List<Category?> categories;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return categories.length != 0
        ? SizedBox(
            height: 70.0,
            child: ListView.builder(
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final item = categories[index];
                final color = (item?.color != null) ? HexColor.fromHex(item!.color!) : ColorApp.dark;

                return Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        CategoryDetailScreen.routeName,
                        arguments: CategoryDetailScreenArgs(item),
                      );
                    },
                    child: CategoryItem(
                      color: color,
                      title: item!.name,
                    ),
                  ),
                );
              },
            ),
          )
        : const SizedBox();
  }
}

class CategoryItem extends StatelessWidget {
  CategoryItem({
    Key? key,
    required this.color,
    required this.title,
  }) : super(key: key);

  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        elevation: 3,
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              unescape.convert(title),
              maxLines: 2,
              textScaleFactor: 1.0,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
