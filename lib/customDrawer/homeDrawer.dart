import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:easy_download/constants/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeDrawer extends StatefulWidget {
  final AnimationController? iconAnimationController;
  final DrawerIndex? screenIndex;
  final Function(DrawerIndex)? callBackIndex;

  const HomeDrawer(
      {Key? key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  late List<DrawerList> drawerList;
  final AdSize adSize = const AdSize(height: 100, width: 320);
  late AdWidget adWidget;
  bool _isBannerAdReady = false;

  late BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-1029928460201419/5459665494',
    size: AdSize.	largeBanner,
    request: const AdRequest(),
    listener:  listener,
  );

  late BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) {
      log('Ad loaded.');
      setState(() {
        _isBannerAdReady = true;
      });
      },
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      log('Ad failed to loaddd: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => log('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => log('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => log('Ad impression.'),
  );

  @override
  void initState() {
    setDrawerListArray();
    myBanner.load();
    adWidget = AdWidget(ad: myBanner);
    super.initState();
  }

  void setDrawerListArray() {
    drawerList = [
      DrawerList(
        index: DrawerIndex.Home,
        labelName: 'Home',
        icon: const Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.Gallery,
        labelName: 'Gallery',
        icon: const Icon(Icons.wallpaper),
      ),
      DrawerList(
        index: DrawerIndex.ShareApp,
        labelName: 'Share the App',
        icon: const Icon(Icons.share),
      ),
      DrawerList(
        index: DrawerIndex.RateApp,
        labelName: 'Rate App',
        icon: const Icon(Icons.star),
      ),
      DrawerList(
        index: DrawerIndex.DonateUs,
        labelName: 'Donate Us',
        icon: const Icon(Icons.monetization_on),
      ),
      // DrawerList(
      //   index: DrawerIndex.About,
      //   labelName: 'About Us',
      //   icon: const Icon(Icons.info),
      // ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      AnimatedBuilder(
                        animation: widget.iconAnimationController!,
                        builder: (BuildContext context, Widget? child) {
                          return ScaleTransition(
                            scale: AlwaysStoppedAnimation(1.0 -
                                (widget.iconAnimationController!.value) * 0.2),
                            child: RotationTransition(
                              turns: AlwaysStoppedAnimation(
                                  Tween(begin: 0.0, end: 24.0)
                                          .animate(CurvedAnimation(
                                              parent: widget
                                                  .iconAnimationController!,
                                              curve: Curves.fastOutSlowIn))
                                          .value /
                                      360),
                              child: Center(
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color:
                                              AppTheme.myPurle.withOpacity(0.1),
                                          blurRadius: 4),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(60.0)),
                                    child:
                                        Image.asset("assets/images/appLogo.png"),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, left: 4),
                          child: Text(
                            "Easy Downloader",
                            style: TextStyle(
                              fontFamily: 'Billabong',
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Divider(
              height: 1,
              color: AppTheme.myPurle.withOpacity(0.5),
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(0.0),
                itemCount: drawerList.length,
                itemBuilder: (context, index) {
                  return inkwell(drawerList[index]);
                },
              ),
            ),
            Divider(
              height: 1,
              color: AppTheme.myPurle.withOpacity(0.6),
            ),
            Column(
              children: <Widget>[
               _isBannerAdReady ? Container(
                  alignment: Alignment.center,
                  child: adWidget,
                  width: myBanner.size.width.toDouble(),
                  height: myBanner.size.height.toDouble(),
                ) : Container(),
                ListTile(
                  title: const Text(
                    "Exit",
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  trailing: const Icon(
                    Icons.power_settings_new,
                    color: Colors.red,
                  ),
                  onTap: () {
                    // myBanner.load();
                    SystemNavigator.pop();
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationToScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? Colors.white
                                  : Theme.of(context).iconTheme.color),
                        )
                      : Icon(listData.icon.icon,
                          color: widget.screenIndex == listData.index
                              ? Colors.white
                              : Theme.of(context).iconTheme.color),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Colors.white
                          : Theme.of(context).iconTheme.color,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController!,
                    builder: (BuildContext context, Widget? child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 32) *
                                (1.0 -
                                    widget.iconAnimationController!.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 32,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                const SizedBox(
                                  width: 6.0,
                                  height: 46.0,
                                  // decoration: BoxDecoration(
                                  //   color: widget.screenIndex == listData.index
                                  //       ? Colors.blue
                                  //       : Colors.transparent,
                                  //   borderRadius: new BorderRadius.only(
                                  //     topLeft: Radius.circular(0),
                                  //     topRight: Radius.circular(16),
                                  //     bottomLeft: Radius.circular(0),
                                  //     bottomRight: Radius.circular(16),
                                  //   ),
                                  // ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(4.0),
                                ),
                                listData.isAssetsImage
                                    ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Image.asset(listData.imageName,
                                      color: widget.screenIndex == listData.index
                                          ? Colors.white
                                          : Theme.of(context).iconTheme.color),
                                )
                                    : Icon(listData.icon.icon,
                                    color: widget.screenIndex == listData.index
                                        ? Colors.white
                                        : Theme.of(context).iconTheme.color),
                                const Padding(
                                  padding: EdgeInsets.all(4.0),
                                ),
                                Text(
                                  listData.labelName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: widget.screenIndex == listData.index
                                        ? Colors.white
                                        : Theme.of(context).iconTheme.color,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  void navigationToScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex!(indexScreen);
  }
}

enum DrawerIndex {
  Home,
  Gallery,
  ShareApp,
  RateApp,
  DonateUs,
}

class DrawerList {
  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;

  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    required this.icon,
    required this.index,
    this.imageName = '',
  });
}
