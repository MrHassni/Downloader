import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:easy_download/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta/flutter_insta.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:easy_download/constants/appConstant.dart';

Directory dir = Directory('/storage/emulated/0/EasyDownload/Instagram');

class InstagramDownload extends StatefulWidget {
  const InstagramDownload({Key? key}) : super(key: key);

  @override
  _InstagramDownloadState createState() => _InstagramDownloadState();
}

class _InstagramDownloadState extends State<InstagramDownload>
    with SingleTickerProviderStateMixin {
  final _igScaffoldKey = GlobalKey<ScaffoldState>();
  FlutterInsta flutterInsta = FlutterInsta();
  final TextEditingController _urlController = TextEditingController();
  String progress = '0';
  double _total = 0;
  bool showBar = false;
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

  bool isDownloaded = false;
  bool validateURL(String urls) {
    String pattern = r'^((http(s)?:\/\/)?((w){3}.)?instagram?(\.com)?\/|).+$';
    RegExp regex = RegExp(pattern);


      if (!regex.hasMatch(urls)) {
        return false;
      }

    return true;
  }



  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(title: Column(
            children: const [
              Text('Are you sure you wanna exit?',style: TextStyle(fontSize: 15),textAlign: TextAlign.center,),
              Text('If download is not completed. The progress will lost.',style: TextStyle(fontSize: 11),textAlign: TextAlign.center,),
            ],
          ),
            content : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyButton(
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  text: 'Yes',
                  color: Theme.of(context).primaryColorDark,
                ),
                MyButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  text: 'No',

                )
              ],
            ),
          ),
    );}


  @override
  void initState() {
    super.initState();
    myBanner.load();
    adWidget = AdWidget(ad: myBanner);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  Future<String> downloadReels(String link) async {
    var linkEdit = link.replaceAll(" ", "").split("/");
    var downloadURL = await http.get(Uri.parse(
        '${linkEdit[0]}//${linkEdit[2]}/${linkEdit[3]}/${linkEdit[4]}'
            "/?__a=1"));
    var data = json.decode(downloadURL.body);
    var graphql = data['graphql'];
    var shortcodeMedia = graphql['shortcode_media'];
    var videoUrl = shortcodeMedia['video_url'];
    return videoUrl; // return download link
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(_total == 0 || _total == 100){
          return true;
        }else{
          log(_total.toString());
          Navigator.of(context).restorablePush(_dialogBuilder);
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        key: _igScaffoldKey,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: screenAppBar("Instagram Downloader")),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/instagramLogo.png",
                    scale: 1.0,
                  ),
                  const Text(
                    ' Instagram\n   Dowloader',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: _urlController,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColorLight,
                            width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColorLight,
                            width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: InkWell(
                        child: Image.asset(
                          'assets/images/instagramLogo.png',
                          scale: 5.0,
                        ),
                      ),
                      hintStyle: const TextStyle(color: Colors.grey),
                      hintText: 'https://www.instagram.com/...'),
                ),
              ),
              const SizedBox(height: 10),
              showBar ? Container(
                height: 150,
                width: 150,
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: LiquidCircularProgressIndicator(
                    center:  Text('${_total.toStringAsFixed(0)}%',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
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
                    text: 'Download',
                    onPressed: () async {
                      log("Pressed");
                      if(validateURL(_urlController.text) == true){
                        var connectivityResult = await Connectivity().checkConnectivity();
                        if (connectivityResult == ConnectivityResult.none) {
                          ScaffoldMessenger.of(context).showSnackBar(mySnackBar(context, 'Check Internet') as SnackBar);
                          return;
                        }
                        var downloadUrl =
                        await flutterInsta.downloadReels(_urlController.text);

                        log(downloadUrl);

                        String _name =  dir.path + '/instagram' + DateTime.now().millisecondsSinceEpoch.toString() + '.mp4';

                        Dio().download(
                          downloadUrl,
                         _name,
                          onReceiveProgress: (received, total) async {
                            if (total != -1) {
                              // print((received / total * 100).toStringAsFixed(0) + "%");
                              setState(() {
                                showBar = true;
                                _total = received / total * 100 ;
                              });

                              if(received / total * 100 == 100){
                                setState(() {
                                  showBar = false;
                                  ScaffoldMessenger.of(context).showSnackBar(mySnackBar(context, 'Download Completed') as SnackBar);
                                  _urlController.text = '';
                                });
                                  // final thumbnailFile = await VideoCompress.getFileThumbnail(
                                  //     dir.path + '/instagram' + '27' + '.mp4',
                                  //     quality: 50, // default(100)
                                  //     position: -1 // default(-1)
                                  // );

                                  // setState(() {
                                  //   newDir = thumbnailFile;
                                  // });

                                  // log(thumbnailFile.path);

                              }
                              //you can build progressbar feature too
                            }
                          },
                          deleteOnError: true,
                        );
                      }else{
                        log('Add Valid Url');
                        ScaffoldMessenger.of(context).showSnackBar(mySnackBar(context, 'Add Valid Url') as SnackBar);
                      }


                      // await FlutterDownloader.enqueue(
                      //   url: downloadUrl,
                      //   savedDir: dir.path,
                      //   fileName: 'instagram' +
                      //       DateTime.now().millisecond.toString() +
                      //       ".mp4",
                      //   showNotification: true,
                      //   openFileFromNotification: true,
                      // );


                    },
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // showBar ? Container(
              //   height: 150,
              //   width: 150,
              //   margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              //   child: ClipRRect(
              //     borderRadius: const BorderRadius.all(Radius.circular(10)),
              //     child: LiquidCircularProgressIndicator(
              //       center:  Text('${_total.toStringAsFixed(0)}%',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              //       backgroundColor: Theme.of(context).primaryColor,
              //       // color: Theme.of(context).primaryColorLight,
              //       // minHeight: 15,
              //       // strokeWidth: 10,
              //       value: _total / 100,
              //     ),
              //   ),
              // )
              //     : Container(),
              _isBannerAdReady ? Container(
                margin: const EdgeInsets.only(top: 25),
                alignment: Alignment.center,
                child: adWidget,
                width: myBanner.size.width.toDouble(),
                height: myBanner.size.height.toDouble(),
              ) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
