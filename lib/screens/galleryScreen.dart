import 'package:flutter/material.dart';
import 'package:easy_download/constants/appConstant.dart';
import 'package:easy_download/screens/facebookDownload/galleryScreen.dart';
import 'package:easy_download/screens/instagramDownload/galleryScreen.dart';
import 'package:easy_download/screens/tiktokDownload/galleryScreen.dart';
import 'package:easy_download/screens/whatsappDownload/galleryScreen.dart';
import 'package:easy_download/screens/youtubeDownload/galleryScreen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> with TickerProviderStateMixin {
  late TabController _galleryTabController;

  @override
  void initState() {
    super.initState();
    _galleryTabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _galleryTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(50),
      child: screenAppBar('App Gallery')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            TabBar(
              controller: _galleryTabController,
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.white,
              isScrollable: true,
              tabs: const <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text('WhatsApp'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text('Youtube'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text('Instagram'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text('Facebook'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text('TikTok'),
                ),
                // Tab(
                //   icon: Icon(Icons.photo_library),
                //   text: 'IMAGES',
                // ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: screenHeightSize(650, context),
              child: TabBarView(
                controller: _galleryTabController,
                children: <Widget>[
                  WhatsappGallery(),
                  YoutubeGallery(),
                  InstagramGallery(),
                  FacebookGallery(),
                  TiktokGallery(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
