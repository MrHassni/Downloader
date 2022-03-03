import 'dart:developer';

import 'package:external_path/external_path.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:easy_download/customDrawer/homeDrawer.dart';
import 'package:easy_download/customDrawer/drawerUserController.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'homeScreen.dart';
import 'galleryScreen.dart';
import 'package:flutter/material.dart';

class NavigationHomeScreen extends StatefulWidget {
  const NavigationHomeScreen({Key? key}) : super(key: key);

  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  late Widget screenView;
  late DrawerIndex drawerIndex;
  late AnimationController sliderAnimationController;

  final RateMyApp _rateApp = RateMyApp(
    preferencesPrefix: 'rateApp_',
    minDays: 3,
    minLaunches: 5,
    remindDays: 2,
    remindLaunches: 4,
    // googlePlayIdentifier: '',
    // appStoreIdentifier: '',
  );

  Future<void> _lauchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        enableJavaScript: true,
        forceWebView: false,
        forceSafariVC: false,
      );
    } else {
      log('Can\'t Launch url');
    }
  }




  @override
  void initState() {
    drawerIndex = DrawerIndex.Home;
    screenView = const MyHomePage();
    super.initState();
    _rateApp.init();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: DrawerUserController(
          screenIndex: drawerIndex,
          drawerWidth: MediaQuery.of(context).size.width * 0.75,
          animationController: (AnimationController animationController) {
            sliderAnimationController = animationController;
          },
          onDrawerCall: (DrawerIndex drawerIndexData) {
            changeIndex(drawerIndexData);
          },
          screenView: screenView,
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexData) {
    if (drawerIndex != drawerIndexData) {
      drawerIndex = drawerIndexData;
      if (drawerIndex == DrawerIndex.Home) {
        setState(() {
          screenView = const MyHomePage();
        });
      } else if (drawerIndex == DrawerIndex.Gallery) {
        setState(() {
          screenView = const GalleryScreen();
        });
      } else if (drawerIndex == DrawerIndex.ShareApp) {
        setState(() {
          Share.share('Download Stories,Videos,Status and much more in One Click using EasyDownload App.\n Checkout the Link below also share it with your Friends.\n https://');
          screenView = const MyHomePage();
          drawerIndex = DrawerIndex.Home;
        });
      } else if (drawerIndex == DrawerIndex.RateApp) {
        _rateApp.showStarRateDialog(
          context,
          title: 'Enjoying using EasyDownload',
          message: 'If you like this app, please rate it !\nIt really helps us and it shouldn\'t take you more than one minute.',
          dialogStyle: const DialogStyle(
            titleAlign: TextAlign.center,
            messagePadding: EdgeInsets.only(bottom: 20.0),
          ),
          actionsBuilder: (context, stars) {
            return [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('LATER'),
              ),
              TextButton(
                onPressed: () {
                  if (stars != 0.0) {
                    _rateApp.save().then((value) => Navigator.pop(context));
                  } else {}
                },
                child: const Text('OK'),
              ),
            ];
          },
          starRatingOptions: const StarRatingOptions(),
        );

        setState(() {
          drawerIndex = DrawerIndex.Home;
          screenView = const MyHomePage();
        });
      } else if (drawerIndex == DrawerIndex.DonateUs) {
        String _donateUrl = 'https://www.buymeacoffee.com';
        _lauchUrl(_donateUrl);
        setState(() {
          drawerIndex = DrawerIndex.Home;
          screenView = const MyHomePage();
        });
      } else if (drawerIndex == DrawerIndex.About) {
        String _donateUrl = 'https://www.linkedin.com/company/rb-sol/';
        _lauchUrl(_donateUrl);
        setState(() {
          drawerIndex = DrawerIndex.Home;
          screenView = const MyHomePage();
        });
      } else {
        //do in your way......
      }
    }
  }
}
