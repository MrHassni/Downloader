import 'package:easy_download/screens/youtubeDownload/youtubeDownloader/pages/home/youtube_homepage.dart';
import 'package:flutter/widgets.dart';
import 'package:easy_download/screens/facebookDownload/facebook_download_page.dart';
import 'package:easy_download/screens/instagramDownload/instagram_download_page.dart';
import 'package:easy_download/screens/whatsappDownload/whatsappDownloadScreen.dart';

class HomeList {
  String title;
  Widget navigateScreen;
  String imagePath;

  HomeList({
    required this.title,
    required this.navigateScreen,
    this.imagePath = '',
  });

  static List<HomeList> homeList = [
    HomeList(
      title: 'Facebook',
      imagePath: 'assets/images/facebookLogo.png',
      navigateScreen: const FacebookDownload(),
    ),
    HomeList(
      title: 'WhatsApp',
      imagePath: 'assets/images/whatsappLogo.png',
      navigateScreen: const WhatsappDownload(),
    ),
    HomeList(
      title: 'Instagram',
      imagePath: 'assets/images/instagramLogo.png',
      navigateScreen: const InstagramDownload(),
    ),
    HomeList(
      title: 'Youtube',
      imagePath: 'assets/images/youtubeLogo.png',
      navigateScreen: const MyYoutubeHomePage(),
    ),
  ];
}

