import 'dart:isolate';
import 'dart:ui';

import 'package:easy_download/screens/youtubeDownload/youtubeDownloader/services/getcommentyt.dart';
import 'package:easy_download/screens/youtubeDownload/youtubeDownloader/services/getvidyt.dart';
import 'package:easy_download/screens/youtubeDownload/youtubeDownloader/services/provider/ytprovider.dart';
import 'package:easy_download/vdeo_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:easy_download/constants/appConstant.dart';
import 'package:easy_download/constants/appTheme.dart';
import 'package:easy_download/screens/navigationHomeScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Easy Download',
      theme: ThemeData(
        primaryColor: Colors.purple,
            primarySwatch: Colors.purple
      ),
      // theme: ThemeData.dark().copyWith(
      //   textTheme: AppTheme.textTheme,
      //   textSelectionColor: Colors.purple,
      //   textSelectionHandleColor: Colors.purple,
      //   platform: TargetPlatform.iOS, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.purple),
      // ),
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
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavigationHomeScreen()));
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
          backgroundColor:  Colors.purple,
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
                  fontSize: 34,
                ),
              ),
              const Text(
                'Download in One Click',
                style: TextStyle(
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
