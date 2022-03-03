import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_download/constants/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_download/constants/appConstant.dart';
import 'package:easy_download/customDrawer/homelist.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late PermissionStatus status;
  int denyCnt = 0;
  List<HomeList> homeList = HomeList.homeList;
  String deviceVersion ='0';


  void _getPermissionOld() async {
      status =  await Permission.storage.request();
    if (status == PermissionStatus.permanentlyDenied) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Storage Permission Required'),
            content: const Text('Enable Storage Permission from App Setting'),
            actions: <Widget>[
              TextButton(
                child: const Text('Open Setting'),
                onPressed: () async {
                  openAppSettings();
                  exit(0);
                },
              )
            ],
          );
        },
      );
    } else {
      while (!status.isGranted) {
        if (denyCnt > 20) {
          exit(0);
        }

          status =  await Permission.storage.request();
        denyCnt++;
      }
    }
  }

  void _getPermissionNew() async {
    status =  await Permission.manageExternalStorage.request();
    if (status == PermissionStatus.permanentlyDenied) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Storage Permission Required'),
            content: const Text('Enable Storage Permission from App Setting'),
            actions: <Widget>[
              TextButton(
                child: const Text('Open Setting'),
                onPressed: () async {
                  openAppSettings();
                  exit(0);
                },
              )
            ],
          );
        },
      );
    } else {
      while (!status.isGranted) {
        if (denyCnt > 20) {
          exit(0);
        }

        status =  await Permission.manageExternalStorage.request();
        denyCnt++;
      }
    }
  }



  InterstitialAd? _interstitialAd;
  int numOfAttemptLoad = 0;

  final AdSize adSize =  const AdSize(height: 250, width: 320);
  late AdWidget adWidget;
  bool _isBannerAdReady = false;

  late BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.mediumRectangle,
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
      log('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => log('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => log('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => log('Ad impression.'),
  );


  void createInterstitial(){
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback:InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad){
            _interstitialAd = ad;
            numOfAttemptLoad =0;
          },
          onAdFailedToLoad: (LoadAdError error){
            numOfAttemptLoad +1;
            _interstitialAd = null;
            if(numOfAttemptLoad<=2){
              createInterstitial();
            }
          }),
    );
  }


  void showInterstitial(){

    if(_interstitialAd == null){
return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(

        onAdShowedFullScreenContent: (InterstitialAd ad){
          log("ad onAdShowedFullscreen");
        },
        onAdDismissedFullScreenContent: (InterstitialAd ad){
          log("ad Disposed");
          ad.dispose();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError aderror){
          log('$ad OnAdFailed $aderror');
          ad.dispose();
          createInterstitial();
        }
    );
    _interstitialAd!.show();
    createInterstitial();
    _interstitialAd = null;
  }
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  info() async {
    var deviceData = <String, dynamic>{};
     final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo _build) {
      return <String, dynamic>{
        'version.securityPatch': _build.version.securityPatch,
        'version.sdkInt': _build.version.sdkInt,
        'version.release': _build.version.release,
        'version.previewSdkInt': _build.version.previewSdkInt,
        'version.incremental': _build.version.incremental,
        'version.codename': _build.version.codename,
        'version.baseOS': _build.version.baseOS,
        'board': _build.board,
        'bootloader': _build.bootloader,
        'brand': _build.brand,
        'device': _build.device,
        'display': _build.display,
        'fingerprint': _build.fingerprint,
        'hardware': _build.hardware,
        'host': _build.host,
        'id': _build.id,
        'manufacturer': _build.manufacturer,
        'model': _build.model,
        'product': _build.product,
        'supported32BitAbis': _build.supported32BitAbis,
        'supported64BitAbis': _build.supported64BitAbis,
        'supportedAbis': _build.supportedAbis,
        'tags': _build.tags,
        'type': _build.type,
        'isPhysicalDevice': _build.isPhysicalDevice,
        'androidId': _build.androidId,
        'systemFeatures': _build.systemFeatures,
      };}
    deviceData =
        _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    setState(() {
      _deviceData = deviceData;
      deviceVersion = _deviceData['version.release'][0] + _deviceData['version.release'][1];
    });
    // log('  [${deviceVersion.toString()}]            hhhhhhhhhhhhh         ');
    if(deviceVersion == '11'){

      _getPermissionNew();
    }else {

      _getPermissionOld();
    }
    }

 static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(title: Column(
            children: const [
              Text('Are you sure you wanna exit?',style: TextStyle(fontSize: 15),textAlign: TextAlign.center,),
              // Text('If download is not completed. The progress will lost.',style: TextStyle(fontSize: 11),textAlign: TextAlign.center,),
            ],
          ),
            content : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyButton(
                  onPressed: (){
                    SystemNavigator.pop();
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

  // CPH1911_11_F.19

  @override
  void initState() {
    super.initState();
    info();
    createInterstitial();
    myBanner.load();
    adWidget = AdWidget(ad: myBanner);
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).restorablePush(_dialogBuilder);
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    appBar(),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: getData(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox();
                          } else {
                            return GridView(
                              padding: const EdgeInsets.only(top: 0, left: 12, right: 12),
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              children: List.generate(
                                homeList.length,
                                (index) {
                                  return HomeListView(
                                    listData: homeList[index],
                                    callBack: () {
                                      showInterstitial();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => homeList[index].navigateScreen,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 5.0,
                                crossAxisSpacing: 5.0,
                                childAspectRatio: 1.0,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    // MaterialButton(
                    //     color: Colors.red,
                    //     onPressed: (){
                    //   info();
                    // }, child: const Text('HHH')),
                    _isBannerAdReady ? Container(
                      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: adWidget,
                      width: MediaQuery.of(context).size.width,
                      // myBanner.size.width.toDouble(),
                      height: myBanner.size.height.toDouble(),
                    ) : Container(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget appBar() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 8),
            child: Container(
              color: Colors.transparent,
              child: SizedBox(
                width: AppBar().preferredSize.height - 8,
                height: AppBar().preferredSize.height - 8,
                child: const Icon(  Icons.menu,color: AppTheme.white,size: 25,),
              ),
            ),
          ),
           const Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  "Easy Download",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Billabong',
                    fontSize: 34,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeListView extends StatelessWidget {
  final HomeList? listData;
  final VoidCallback? callBack;
  final AnimationController? animationController;
  final Animation? animation;

  const HomeListView({Key? key, this.listData, this.callBack, this.animationController, this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: screenWidthSize(80, context),
          height: screenWidthSize(80, context),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF1D1E33),
            child: ClipOval(
              child: Stack(
                alignment: AlignmentDirectional.center,
                fit: StackFit.expand,
                children: <Widget>[
                  Image.asset(
                    listData!.imagePath,
                    fit: BoxFit.cover,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.grey.withOpacity(0.2),
                      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                      onTap: () {
                        callBack!();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            listData!.title,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.white
            ),
          ),
        ),
      ],
    );
  }
}
