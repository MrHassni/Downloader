import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_download/constants/appConstant.dart';
import 'package:easy_download/screens/facebookDownload/getting_fb_url_data.dart';
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

  @override
  void initState() {
    super.initState();
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    prefixIcon: InkWell(
                      child: Image.asset(
                        'assets/images/facebookLogo.png',
                        scale: 3.0,
                      ),
                    ),
                    hintText: 'https://www.facebook.com/...'),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MyButton(
                  text: 'PASTE',
                  onPressed: () async {
                    Map<String, dynamic> result = await SystemChannels.platform
                        .invokeMethod('Clipboard.getData');
                    WidgetsBinding.instance!.addPostFrameCallback(
                      (_) => _urlController.text = result['text'].toString(),
                    );
                  },
                ),
                MyButton(
                    text: 'Download',
                    onPressed: () async {
                      // var _fbProfile = (await FacebookData.postFromUrl(
                      //     '${_urlController.text}'));
                      // log(_fbProfile.videoMp3Url!);

                      //   down.FacebookPost data = await down.FacebookData.postFromUrl(
                      //       "https://www.facebook.com/watch/?v=135439238028475");
                      //   print(data.postUrl.toString() + 'Post Url');
                      //   print(data.videoHdUrl.toString() + 'Video Url');
                      //   print(data.videoMp3Url.toString() + 'MP3Video Url');
                      //   print(data.videoSdUrl.toString() + 'Sd Url');
                      //   print(data.commentsCount.toString() + 'Comment Url');
                      //   print(data.sharesCount.toString() + 'Share Url');
                      // }

                      // setState(() {
                    //     html = '''
                    //       <iframe width="200" height='200'
                    //        src="https://www.facebook.com/v2.3/plugins/video.php?
                    //        href=${_urlController.text}" </iframe>
                    // ''';

    //
    //                   var t = '''
    //                   <iframe
    //
    //                   $options  = array('http' => array('user_agent' => 'custom user agent string'));
    // $context  = stream_context_create($options);
    // $response = file_get_contents('__PASTE_FACEBBOOK_VIDEO_LINK_HERE__', false, $context);
    // preg_match_all('#\bhttps?://[^,\s()<>]+(?:\([\w\d]+\)|([^,[:punct:]\s]|/))#', strip_tags($response), $match);
    // $searchword = 'video';
    // $matches = array_filter($match[0], function($var) use ($searchword) { return preg_match("/\b$searchword\b/i", $var); });
    // $filename = rand().".mp4";
    // file_put_contents($filename, fopen(reset($matches), 'r'));
    //                   </iframe>
    //                   ''';


                      // showBar = true;
//                                          });
// //
// log(html);
//
//

// //
//                           if(validateURL(_urlController.text) == false){
                            var connectivityResult = await Connectivity().checkConnectivity();
                            log(connectivityResult.toString());
                            if (connectivityResult == ConnectivityResult.none) {
                              ScaffoldMessenger.of(context).showSnackBar(mySnackBar(context,'Check Internet') as SnackBar);
                              return;
                            }
                          var  _fb = await GettingFacebookURLData.postFromUrl(_urlController.text);
                          log(_fb.toString());
                          if(_fb == ''){
                            ScaffoldMessenger.of(context).showSnackBar(mySnackBar(context, 'No Video In This URL') as SnackBar);
                          }else{
                            Dio().download(
                              _fb,
                              dir.path + '/facebook' + DateTime.now().millisecondsSinceEpoch.toString() + '.mp4',
                              onReceiveProgress: (received, total) {
                                // log('h                hh      ' + total.toString());
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
                                  }
                                }
                              },
                              deleteOnError: true,
                            );
                          }
                          // }else{
                          //   log('Add Valid Url');
                          //   ScaffoldMessenger.of(context).showSnackBar(mySnackBar(context, 'Add Valid Url') as SnackBar);
                          // }
                        },
                    ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            showBar
                ?

                // HtmlWidget(
                //   html,
                //   webView: true,
                // )

                Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColorDark,
                        color: Theme.of(context).primaryColorLight,
                        minHeight: 15,
                        value: _total / 100,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
