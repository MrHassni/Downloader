import 'dart:developer';

import 'package:easy_download/screens/navigationHomeScreen.dart';
import 'package:easy_download/screens/onboardingScreen/on_boarding_screen.dart';
import 'package:easy_download/screens/youtubeDownload/youtubeDownloader/services/getcommentyt.dart';
import 'package:easy_download/screens/youtubeDownload/youtubeDownloader/services/getvidyt.dart';
import 'package:easy_download/screens/youtubeDownload/youtubeDownloader/services/provider/ytprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:easy_download/constants/appConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';


int? isviewed;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');
  MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await FlutterDownloader.initialize(debug: true // optional: set false to disable printing logs to console
      );
  runApp( MultiProvider(
    providers: [
      ChangeNotifierProvider<GetVideosFromYT>(
        create: (BuildContext context) => GetVideosFromYT(),
      ),
      ChangeNotifierProvider<GetCommentsFromYT>(
        create: (BuildContext context) => GetCommentsFromYT(),
      ),
      ChangeNotifierProvider<GetCommentsFromYT>(
        create: (BuildContext context) => GetCommentsFromYT(),
      ),
      ChangeNotifierProvider<YoutubeDownloadProvider>(
        create: (BuildContext context) => YoutubeDownloadProvider(),
      ),
    ],
    child:  MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);
  final Map<int, Color> _blue = {
    50:  const Color(0xFFe8e8ea),
    100: const Color(0xFFd1d2d6),
    200: const Color(0xFFbbbbc1),
    300: const Color(0xFFa4a5ad),
    400: const Color(0xFF8e8e99),
    500: const Color(0xFF777884),
    600: const Color(0xFF606170),
    700: const Color(0xFF4a4a5b),
    800: const Color(0xFF333447),
    900: const Color(0xFF1D1E33),
  };

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Easy Download',
      theme: ThemeData(
            primarySwatch:  MaterialColor(0xFF1D1E33,_blue)
      ),

      debugShowCheckedModeBanner: false,
      home: const WelcomeLogo(),
    );
  }
}

class WelcomeLogo extends StatefulWidget {
  const WelcomeLogo({Key? key}) : super(key: key);

  @override
  _WelcomeLogoState createState() => _WelcomeLogoState();
}

class _WelcomeLogoState extends State<WelcomeLogo> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      log(isviewed.toString());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  isviewed != 0 ?  const OnBoardingScreen() : const NavigationHomeScreen()));
    });
  }

  // final ReceivePort _port = ReceivePort();
  //
  // @override
  // void initState() {
  //   super.initState();
  //
  //   _bindBackgroundIsolate();
  //
  //   FlutterDownloader.registerCallback(downloadCallback);
  //   Future.delayed(const Duration(seconds: 3), () {
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavigationHomeScreen()));
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   _unbindBackgroundIsolate();
  //   super.dispose();
  // }
  //
  // void _bindBackgroundIsolate() {
  //   bool isSuccess = IsolateNameServer.registerPortWithName(
  //       _port.sendPort, 'downloader_send_port');
  //   if (!isSuccess) {
  //     _unbindBackgroundIsolate();
  //     _bindBackgroundIsolate();
  //     return;
  //   }
  //   _port.listen((dynamic data) {
  //   });
  // }
  //
  // void _unbindBackgroundIsolate() {
  //   IsolateNameServer.removePortNameMapping('downloader_send_port');
  // }
  //
  // static void downloadCallback(
  //     String id, DownloadTaskStatus status, int progress) {
  //   final SendPort send =
  //   IsolateNameServer.lookupPortByName('downloader_send_port')!;
  //   send.send([id, status, progress]);
  // }
  //


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Scaffold(
          backgroundColor:  const Color(0xFF1D1E33),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: screenHeightSize(650, context),
              ),
              Image.asset(
                'assets/images/appLogo.png',
                height: screenWidthSize(200, context),
                width: screenWidthSize(200, context),
              ),
              const Text(
                'Easy Download',
                style: TextStyle(
                  fontFamily: 'Billabong',
                  color: Colors.white,
                  fontSize: 34,
                ),
              ),
              const Text(
                'Download in One Click',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
