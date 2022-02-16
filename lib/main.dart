import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:easy_download/constants/appConstant.dart';
import 'package:easy_download/constants/appTheme.dart';
import 'package:easy_download/screens/navigationHomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await FlutterDownloader.initialize(debug: true // optional: set false to disable printing logs to console
      );
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Download',
      theme: ThemeData.dark().copyWith(
        textTheme: AppTheme.textTheme,
        accentColor: Colors.blue,
        textSelectionColor: Colors.blue,
        textSelectionHandleColor: Colors.blue,
        platform: TargetPlatform.iOS,
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
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavigationHomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Scaffold(
          backgroundColor: ThemeData.dark().primaryColor,
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
                'All In One Download in One Click',
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
