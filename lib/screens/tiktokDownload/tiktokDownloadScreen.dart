import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:easy_download/constants/appConstant.dart';
import 'package:easy_download/screens/tiktokDownload/tiktokData.dart';

Directory dir = Directory('/storage/emulated/0/EasyDownload/Tiktok');
Directory thumbDir = Directory('/storage/emulated/0/.easydownload/.thumbs');

class TiktokDownload extends StatefulWidget {
  const TiktokDownload({Key? key}) : super(key: key);

  @override
  _TiktokDownloadState createState() => _TiktokDownloadState();
}

class _TiktokDownloadState extends State<TiktokDownload> {
  final _ttScaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _urlController = TextEditingController();
   TiktokProfile? _ttProfile;
  bool _isDisabled = false, _showData = false, _notfirst = false, _isPrivate = false;

  // bool validateURL(List<String> urls) {
  //   // String pattern = r'^(http(s)?:\/\/)?((w){3}.)?tiktok?(\.com)?\/.+/video\/.+$';
  //   // RegExp regex =  RegExp(r'^(http(s)?:\/\/)?((w){3}.)?tiktok?(\.com)?\/.+/video\/.+$');
  //
  //   for (var url in urls) {
  //     if (!regex.hasMatch(url)) {
  //       return false;
  //     }
  //   }
  //   return true;
  // }

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

  @override
  void initState() {
    super.initState();
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    if (!thumbDir.existsSync()) {
      thumbDir.createSync(recursive: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _ttScaffoldKey,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: screenAppBar("Tiktok Downloader")),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/tiktokLogo.png",
                  scale: 5.0,
                ),
                const Text(
                  ' TikTok\n   Dowloader',
                  style: TextStyle(
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
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                    prefixIcon: InkWell(
                      child: Image.asset(
                        'assets/images/tiktokLogo.png',
                        scale: 14.0,
                      ),
                    ),
                    hintText: 'https://www.tiktok.com/...'),
                // onChanged: (value) {
                //   getButton(value);
                // },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MyButton(
                  text: 'PASTE',
                  onPressed: () async {
                    Map<String, dynamic> result = await SystemChannels.platform.invokeMethod('Clipboard.getData');
                    WidgetsBinding.instance!.addPostFrameCallback(
                      (_) => _urlController.text = result['text'].toString(),
                    );
                    // setState(() {
                    //   getButton(result['text'].toString());
                    // });
                  },
                ),
                _isDisabled
                    ? MyButton(
                        text: 'Download',
                        onPressed: () async {
                          log('noo');
                        })
                    : MyButton(
                        text: 'Download',
                        onPressed: () async {
                          log('message');
                          var connectivityResult = await Connectivity().checkConnectivity();
                          if (connectivityResult == ConnectivityResult.none) {
                            _ttScaffoldKey.currentState!.showSnackBar(mySnackBar(context, 'No Internet') as SnackBar);
                            return;
                          }
                          setState(() {
                            _notfirst = true;
                            _showData = false;
                          });
                          _ttProfile = (await TiktokData.postFromUrl(_urlController.text))!;
                          if (_ttProfile!.profileUrl == null) {
                            _ttScaffoldKey.currentState!.showSnackBar(mySnackBar(context, 'Sorry Unable to Connect') as SnackBar);
                            setState(() {
                              _notfirst = false;
                            });
                            return;
                          }
                          setState(() {
                            _showData = true;
                          });
                        },
                      ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            _isPrivate
                ? const Text(
                    'This Account is Private',
                    style: TextStyle(fontSize: 14.0),
                  )
                : Container(),
            _notfirst
                ? _showData
                    ? Container(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        margin: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: screenHeightSize(350, context),
                          child: GridView.builder(
                            itemCount: 1,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              String _postDescription = '';

                              return Column(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Container(
                                        height: screenHeightSize(200, context),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                        ),
                                        child: ProgressiveImage(
                                          placeholder: const AssetImage('assets/images/placeholder_video.gif'),
                                          thumbnail: NetworkImage(_ttProfile!.videoData!.thumbnailUrl!),
                                          image: NetworkImage(_ttProfile!.videoData!.thumbnailUrl!),
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      const Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(Icons.videocam),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0, left: 5.0),
                                    child: GestureDetector(
                                      child: Text(
                                        _ttProfile!.videoData!.description!,
                                        style: const TextStyle(fontSize: 14.0),
                                      ),
                                      onTap: () async {
                                        Clipboard.setData(ClipboardData(text: _postDescription));
                                        _ttScaffoldKey.currentState!.showSnackBar(mySnackBar(context, 'Caption Copied') as SnackBar);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: MyButton(
                                      text: 'Download',
                                      padding: const EdgeInsets.all(5.0),
                                      color: Theme.of(context).accentColor,
                                      // onPressed: _isDown
                                      //     ? null
                                      //     : () async {
                                      //         var _downloadUrl = _ttProfile.videoData.videoWatermarkUrl;
                                      //         _downloadDialog(context, _downloadUrl);
                                      //       },
                                      onPressed: () async {
                                        _ttScaffoldKey.currentState!.showSnackBar(mySnackBar(context, 'Added to Download') as SnackBar);
                                        String downloadUrl = _ttProfile!.videoData!.videoWatermarkUrl!;
                                        String name = 'TT-${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.mp4';

                                        String thumbUrl = _ttProfile!.videoData!.thumbnailUrl!;
                                        await FlutterDownloader.enqueue(
                                          url: thumbUrl,
                                          savedDir: thumbDir.path,
                                          fileName: name.substring(0, name.length - 3) + 'jpg',
                                          showNotification: false,
                                        );

                                        await FlutterDownloader.enqueue(
                                          url: downloadUrl,
                                          savedDir: dir.path,
                                          fileName: name,
                                          showNotification: true,
                                          openFileFromNotification: true,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 5.0,
                              crossAxisSpacing: 10.0,
                              childAspectRatio: 1,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 100,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                : Container(),
          ],
        ),
      ),
    );
  }
}
