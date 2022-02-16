import 'package:flutter/widgets.dart';
import 'package:easy_download/screens/facebookDownload/facebookDownloadScreen.dart';
import 'package:easy_download/screens/instagramDownload/instagramDownloadScreen.dart';
import 'package:easy_download/screens/tiktokDownload/tiktokDownloadScreen.dart';
import 'package:easy_download/screens/whatsappDownload/whatsappDownloadScreen.dart';
import 'package:easy_download/screens/youtubeDownload/youtubeDownloadScreen.dart';

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
      navigateScreen: FacebookDownload(),
    ),
    HomeList(
      title: 'WhatsApp',
      imagePath: 'assets/images/whatsappLogo.png',
      navigateScreen: WhatsappDownload(),
    ),
    HomeList(
      title: 'Instagram',
      imagePath: 'assets/images/instagramLogo.png',
      navigateScreen: InstagramDownload(),
    ),
    HomeList(
      title: 'Youtube',
      imagePath: 'assets/images/youtubeLogo.png',
      navigateScreen: YoutubeDownload(),
    ),
    HomeList(
      title: 'Tiktok',
      imagePath: 'assets/images/tiktokLogo.png',
      navigateScreen: TiktokDownload(),
    ),
  ];
}

