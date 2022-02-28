/* import 'package:flutter/material.dart'; */
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../../../../constants/appConstant.dart';
import '../../pages/home/body.dart';
import '../../utils/const.dart';

import 'body.dart';

/// my home page
class MyYoutubeHomePage extends StatelessWidget {
  /// constractor
  const MyYoutubeHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: screenAppBar("YouTube Downloader")),
      // appBar: myAppBar(
      //   context,
      //   'Youtube Downloader',
      //   isNavBack.no,
      //   isDown.yes,
      //   isDispo.no,
      // ),
      body: const MyBody(),
    );
  }
}
