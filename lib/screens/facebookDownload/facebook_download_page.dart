import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_download/constants/appConstant.dart';
import 'package:easy_download/screens/facebookDownload/getting_fb_url_data.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

Directory dir = Directory('/storage/emulated/0/EasyDownload/Facebook');

class FacebookDownload extends StatefulWidget {
  const FacebookDownload({Key? key}) : super(key: key);

  @override
  _FacebookDownloadState createState() => _FacebookDownloadState();
}

class _FacebookDownloadState extends State<FacebookDownload> {
  final _fbScaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _urlController = TextEditingController();
  double _total = 0;
  bool showBar = false;
  late String html;
  final AdSize adSize = const AdSize(height: 100, width: 320);
  late AdWidget adWidget;
  bool _isBannerAdReady = false;

  late BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-1029928460201419/5459665494',
    size: AdSize.largeBanner,
    request: const AdRequest(),
    listener: listener,
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

  // Future<String> _loadthumb(String videoUrl) async {
  //   thumb = await VideoThumbnail.thumbnailFile(
  //     video: videoUrl,
  //     thumbnailPath: thumbDir.path,
  //     imageFormat: ImageFormat.PNG,
  //   );
  //   var rep = thumb.toString().substring(thumb.toString().indexOf('ThumbFiles/') + 'ThumbFiles/'.length, thumb.toString().indexOf('.mp4'));
  //   File thumbname = File(thumb.toString());
  //   thumbname.rename(thumbDir.path + '$rep.png');
  //
  //   print(thumbDir.path + '$rep.png');
  //   return (thumbDir.path + '$rep.png');
  // }

  bool validateURL(String urls) {
    String pattern = r'^(http(s)?:\/\/)?((w){3}.)?facebook?(\.com)?\/.+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(urls)) {
      return false;
    }
    return true;
  }

  // void getButton(String url) {
  //   if (validateURL([url])) {
  //     setState(() {
  //       _isDisabled = false;
  //     });
  //   } else {
  //     setState(() {
  //       _isDisabled = true;
  //     });
  //   }
  // }

  Future<void> getPath_1() async {
    var path = await ExternalPath.getExternalStorageDirectories();
    print(path.first +
        '           vvvvvvvvvvvvv           ' +
        dir.path); // [/storage/emulated/0, /storage/B3AE-4D28]

    // please note: B3AE-4D28 is external storage (SD card) folder name it can be any.
  }

  @override
  void initState() {
    getPath_1();
    super.initState();
    myBanner.load();
    adWidget = AdWidget(ad: myBanner);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Column(
          children: const [
            Text(
              'Are Sure You Wanna Exit?',
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            Text(
              'If download is not completed. The progress will lost.',
              style: TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MyButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              text: 'Yes',
              color: Theme.of(context).primaryColorDark,
            ),
            MyButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: 'No',
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_total == 0 || _total == 100) {
          return true;
        } else {
          log(_total.toString());
          Navigator.of(context).restorablePush(_dialogBuilder);
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        key: _fbScaffoldKey,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: screenAppBar("Facebook Downloader")),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/facebookLogo.png",
                    scale: 1.0,
                  ),
                  const Text(
                    ' Facebook\n   Downloader',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.text,
                  controller: _urlController,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      prefixIcon: InkWell(
                        child: Image.asset(
                          'assets/images/facebookLogo.png',
                          scale: 3.0,
                        ),
                      ),
                      hintStyle: const TextStyle(color: Colors.grey),
                      hintText: 'https://www.facebook.com/...'),
                ),
              ),
              const SizedBox(height: 10),
              showBar
                  ? Container(
                      height: 150,
                      width: 150,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.1),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: LiquidCircularProgressIndicator(
                          center: Text(
                            '${_total.toStringAsFixed(0)}%',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                          // color: Theme.of(context).primaryColorLight,
                          // minHeight: 15,
                          // strokeWidth: 10,
                          value: _total / 100,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        MyButton(
                          text: 'PASTE',
                          onPressed: () async {
                            Map<String, dynamic> result = await SystemChannels
                                .platform
                                .invokeMethod('Clipboard.getData');
                            WidgetsBinding.instance!.addPostFrameCallback(
                              (_) => _urlController.text =
                                  result['text'].toString(),
                            );
                          },
                        ),
                        MyButton(
                          text: 'Download',
                          onPressed: () async {
                            var connectivityResult =
                                await Connectivity().checkConnectivity();
                            log(connectivityResult.toString());
                            if (connectivityResult == ConnectivityResult.none) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  mySnackBar(context, 'Check Internet')
                                      as SnackBar);
                              return;
                            }
                            var _fb = await GettingFacebookURLData.postFromUrl(
                                _urlController.text);
                            log(_fb.toString());
                            if (_fb == '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  mySnackBar(context, 'No Video In This URL')
                                      as SnackBar);
                            } else {
                              try {
                                Dio().download(
                                  _fb,
                                  dir.path +
                                      '/facebook' +
                                      DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString() +
                                      '.mp4',
                                  onReceiveProgress: (received, total) {
                                    // log('h                hh      ' + total.toString());
                                    if (total != -1) {
                                      // print((received / total * 100).toStringAsFixed(0) + "%");
                                      setState(() {
                                        showBar = true;
                                        _total = received / total * 100;
                                      });
                                      if (received / total * 100 == 100) {
                                        setState(() {
                                          showBar = false;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(mySnackBar(context,
                                                      'Download Completed')
                                                  as SnackBar);
                                          _urlController.text = '';
                                        });
                                      }
                                    }
                                  },
                                  deleteOnError: true,
                                );
                              } catch (_e) {
                                log(_e.toString());
                                AlertDialog(
                                  title: const Text(
                                      'Check your internet and try again.'),
                                  actions: [
                                    MaterialButton(
                                      // FlatButton widget is used to make a text to work like a button
                                      textColor: Colors.black,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      // function used to perform after pressing the button
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
              // showBar
              //     ?

              // HtmlWidget(
              //   html,
              //   webView: true,
              // )

              // Container(
              //     margin: EdgeInsets.symmetric(
              //         horizontal: MediaQuery.of(context).size.width * 0.1),
              //     child: ClipRRect(
              //       borderRadius: const BorderRadius.all(Radius.circular(10)),
              //       child: LinearProgressIndicator(
              //         backgroundColor: Theme.of(context).primaryColorDark,
              //         color: Theme.of(context).primaryColorLight,
              //         minHeight: 15,
              //         value: _total / 100,
              //       ),
              //     ),
              //   )
              // : Container(),
              _isBannerAdReady
                  ? Container(
                      alignment: Alignment.bottomCenter,
                      child: adWidget,
                      width: myBanner.size.width.toDouble(),
                      height: myBanner.size.height.toDouble(),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
