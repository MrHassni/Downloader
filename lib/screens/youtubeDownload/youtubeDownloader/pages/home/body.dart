import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../../constants/appConstant.dart';
import '../../pages/results/results.dart';

import '../../utils/const.dart';

/// most download page
class MyBody extends StatefulWidget {
  const MyBody({Key? key}) : super(key: key);

  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  final String _myTitle = 'Search Video';
final TextEditingController _urlController = TextEditingController();

  /// hislks
  final SearchTo _st = SearchTo.video;
  final AdSize adSize = const AdSize(height: 100, width: 320);
  late AdWidget adWidget;
  bool _isBannerAdReady = false;

  late BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
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
    super.initState();
    myBanner.load();
    adWidget = AdWidget(ad: myBanner);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/youtubeLogo.png",
                scale: 1.0,
              ),
              const Text(
                ' YouTube\n   Downloader',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Text('Search or Paste The Link Here'),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  maxLines: 1,
                  controller: _urlController,
                  decoration: InputDecoration(
                    prefixIcon: InkWell(
                      child: Image.asset(
                        'assets/images/youtubeLogo.png',
                        scale: 5.0,
                      ),
                    ),

                    enabledBorder:OutlineInputBorder(
                      borderSide:  BorderSide(color: Theme.of(context).primaryColorLight, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide:  BorderSide(color: Theme.of(context).primaryColorLight, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintStyle: const TextStyle(color: Colors.grey),
                    hintText: _myTitle,
                  ),

                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    text: 'PASTE',
                    onPressed: () async {
                      Map<String, dynamic> result = await SystemChannels.platform
                          .invokeMethod('Clipboard.getData');
                      result['text'] = result['text']
                          .toString()
                          .replaceAll(RegExp(r'\?igshid=.*'), '');
                      result['text'] = result['text']
                          .toString()
                          .replaceAll(RegExp(r'https://instagram.com/'), '');
                      WidgetsBinding.instance!.addPostFrameCallback(
                            (_) => _urlController.text = result['text']
                            .toString()
                            .replaceAll(RegExp(r'\?igshid=.*'), ''),
                      );
                    },
                  ),
                  MyButton(
                      text: 'Search',
                      onPressed: (){
                    if (_urlController.text.isNotEmpty) {
                      Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>ShowingResult(query: _urlController.text, st: _st, isDispoQuery: isDispo.yes,)));
                    }
                  }),
                ],
              ),

              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.4,
              //   child: MaterialButton(
              //     color: Theme.of(context).primaryColorDark,
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 10,
              //       vertical: 15,
              //     ),
              //     onPressed: () {
              //       if (val.isNotEmpty) {
              //         Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>ShowingResult(query: val, st: _st, isDispoQuery: isDispo.yes,)));
              //       }
              //     },
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: const <Widget>[
              //         Icon(
              //           Icons.search,
              //           size: 20,
              //           color: Colors.white,
              //         ),
              //         SizedBox(width: 5),
              //         Text(
              //           'Search',
              //         ),
              //       ],
              //     ),
              //   ),
              // )
              _isBannerAdReady ? Container(
                alignment: Alignment.bottomCenter,
                child: adWidget,
                width: myBanner.size.width.toDouble(),
                height: myBanner.size.height.toDouble(),
              ) : Container(),
            ],
          )
        ],
      ),
    );
  }
}
