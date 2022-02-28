import 'package:easy_download/screens/youtubeDownload/youtubeDownloader/pages/download/downloadpage.dart';
import 'package:flutter/material.dart';
import 'package:easy_download/constants/appConstant.dart';
import 'package:easy_download/screens/facebookDownload/fb_gallery.dart';
import 'package:easy_download/screens/instagramDownload/insta_gallery.dart';
import 'package:easy_download/screens/whatsappDownload/whatsapp_gallery.dart';

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
    _galleryTabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _galleryTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
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
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: screenHeightSize(650, context),
              child: TabBarView(
                controller: _galleryTabController,
                children: const <Widget>[
                  WhatsappGallery(),
                  YoutubeDownloadPage(),
                  InstaGallery(),
                  FbGallery(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
