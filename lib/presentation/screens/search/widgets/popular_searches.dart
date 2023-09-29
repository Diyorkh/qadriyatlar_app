import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qadriyatlar_app/core/env.dart';
import 'package:qadriyatlar_app/main.dart';
import 'package:qadriyatlar_app/presentation/screens/search_detail/search_detail_screen.dart';
import 'package:qadriyatlar_app/theme/app_color.dart';

class PopularSearches extends StatefulWidget {
  const PopularSearches({super.key, required this.popularSearch});

  final List<String?> popularSearch;

  @override
  State<PopularSearches> createState() => _PopularSearchesState();
}

class _PopularSearchesState extends State<PopularSearches> {
  @override
  Widget build(BuildContext context) {
    return widget.popularSearch.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TODO: 29.09.2023 Add translations
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 15.0),
                child: Text(
                  localizations.getLocalization('popular_searchs'),
                  textScaleFactor: 1.0,
                  style: Theme.of(context).primaryTextTheme.headlineSmall?.copyWith(
                        color: ColorApp.dark,
                        fontStyle: FontStyle.normal,
                      ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.popularSearch.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = widget.popularSearch[index];
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        SearchDetailScreen.routeName,
                        arguments: SearchDetailScreenArgs(searchText: item),
                      );
                    },
                    leading: Icon(
                      Icons.search,
                      color: ColorApp.mainColor,
                    ),
                    title: Text(
                      unescape.convert(item ?? ''),
                      style: GoogleFonts.lato(fontSize: 17, fontWeight: FontWeight.w400),
                    ),
                  );
                },
              ),
              Divider(
                height: 10,
                indent: 65,
                color: Colors.grey,
              ),
            ],
          )
        : const SizedBox();
  }
}
