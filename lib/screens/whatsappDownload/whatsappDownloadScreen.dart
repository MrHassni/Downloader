import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_download/constants/appConstant.dart';
import 'package:easy_download/screens/whatsappDownload/imageScreen.dart';
import 'package:easy_download/screens/whatsappDownload/videoScreen.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

final Directory _videoDir = Directory('/storage/emulated/0/WhatsApp/Media/.Statuses/');
final Directory thumbDir = Directory('/storage/emulated/0/.easydownload/.thumbs/');

class WhatsappDownload extends StatefulWidget {
  const WhatsappDownload({Key? key}) : super(key: key);

  @override
  _WhatsappDownloadState createState() => _WhatsappDownloadState();
}

class _WhatsappDownloadState extends State<WhatsappDownload> with TickerProviderStateMixin {
  late TabController _whatsappTabController;
  final _scaffoldKey =  GlobalKey<ScaffoldState>();

  _loadthumb() async {
    if (Directory(_videoDir.path).existsSync()) {
      var videoList = _videoDir.listSync().map((item) => item.path).where((item) => item.endsWith(".mp4")).toList(growable: false);

      for (var x in videoList) {
        var tmp = x.replaceAll(_videoDir.path.toString(), '');

        if (!File(thumbDir.path.toString() + tmp.substring(0, tmp.length - 4) + '.png').existsSync()) {
          await VideoThumbnail.thumbnailFile(
            video: x,
            thumbnailPath: thumbDir.path,
            imageFormat: ImageFormat.PNG,
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _whatsappTabController = TabController(length: 2, vsync: this);
    if (!thumbDir.existsSync()) {
      thumbDir.createSync(recursive: true);
    }
    _loadthumb();
  }

  @override
  void dispose() {
    super.dispose();
    _whatsappTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      key: _scaffoldKey,
      appBar: PreferredSize(preferredSize: const Size.fromHeight(50),
      child: screenAppBar("WhatsApp Downloader")),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/images/whatsappLogo.png", scale: 1.0),
                const Text(
                  ' WhatsApp Status\n   Downloader',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            TabBar(controller: _whatsappTabController, indicatorColor: Colors.blue, labelColor: Colors.green, unselectedLabelColor: Colors.white, labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0), isScrollable: false, unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12.0), tabs: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(Icons.photo_library),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('IMAGES'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(Icons.live_tv),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('VIDEOS'),
                    ),
                  ],
                ),
              ),
            ]),
            SizedBox(
              height: screenHeightSize(400, context),
              child: TabBarView(
                controller: _whatsappTabController,
                children: <Widget>[
                  WAImageScreen(
                    scaffoldKey: _scaffoldKey,
                  ),
                  WAVideoScreen(
                    scaffoldKey: _scaffoldKey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
