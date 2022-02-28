import 'package:easy_download/screens/youtubeDownload/youtubeDownloader/pages/results/showallresults.dart';
import 'package:flutter/material.dart';


import '../../utils/const.dart';


/// view search result

class ShowingResult extends StatelessWidget {
  /// constractor
  const ShowingResult({
    Key? key,
    required this.query,
    required this.st,
    required this.isDispoQuery,
  }) : super(key: key);

  /// search query
  final String query;

  /// search to where
  final SearchTo st;

  /// search to where
  final isDispo isDispoQuery;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // backgroundColor: kprimaryColorD,
      // appBar: myAppBar(context, query, isNavBack.yes, isDown.yes, isDispoQuery),
      body: ShowingListOfVideos(
        query: query,
        where: st,
      ),
    );
  }
}
