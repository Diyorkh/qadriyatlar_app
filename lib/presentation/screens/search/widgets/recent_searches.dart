import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qadriyatlar_app/presentation/screens/search/components/recent_search_service.dart';
import 'package:qadriyatlar_app/presentation/screens/search_detail/search_detail_screen.dart';
import 'package:qadriyatlar_app/theme/app_color.dart';

class RecentSearches extends StatelessWidget {
  const RecentSearches({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (Provider.of<RecentSearchService>(context).recentSearch.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // TODO: 29.09.2023 Add translations
                Text(
                  'Recent Searches',
                  textScaleFactor: 1.0,
                  style: Theme.of(context).primaryTextTheme.headlineSmall?.copyWith(
                        color: ColorApp.dark,
                        fontStyle: FontStyle.normal,
                      ),
                ),
                // TODO: 29.09.2023 Add translations
                InkWell(
                  onTap: () => Provider.of<RecentSearchService>(context, listen: false).deleteRecentSearches(),
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
          itemCount: Provider.of<RecentSearchService>(context).recentSearch.length,
          itemBuilder: (BuildContext context, int index) {
            final item = Provider.of<RecentSearchService>(context).recentSearch[index];
            return ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(
                  SearchDetailScreen.routeName,
                  arguments: SearchDetailScreenArgs(
                    searchText: item,
                  ),
                );
              },
              leading: Icon(
                Icons.search,
                color: ColorApp.mainColor,
              ),
              title: Text(
                item,
                style: GoogleFonts.lato(fontSize: 17, fontWeight: FontWeight.w400),
              ),
            );
          },
        ),
      ],
    );
  }
}
