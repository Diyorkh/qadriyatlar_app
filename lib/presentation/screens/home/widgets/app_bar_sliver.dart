import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qadriyatlar_app/theme/app_color.dart';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double fontSize = 28 - (4 * shrinkOffset / 90);

    return AppBar(
      elevation: 0.0,
      surfaceTintColor: ColorApp.white,
      backgroundColor: Colors.white,
      toolbarHeight: 120 - shrinkOffset,
      title: TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: 0.6),
        duration: const Duration(milliseconds: 300),
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Salom,',
                style: TextStyle(
                  fontSize: fontSize * value,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Mirolim Yadgarov',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 38 * value,
                  color: Colors.black,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => 120.0; // Increase the maxExtent value

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
