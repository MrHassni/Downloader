import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta/flutter_insta.dart';
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

  bool isDownloaded = false;
  bool validateURL(String urls) {
    String pattern = r'^((http(s)?:\/\/)?((w){3}.)?instagram?(\.com)?\/|).+$';
    RegExp regex = RegExp(pattern);


      if (!regex.hasMatch(urls)) {
        return false;
      }

    return true;
  }


  @override
  void initState() {
    super.initState();
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
    return Scaffold(
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
                    hintText: 'https://www.instagram.com/...'),
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
            showBar ? Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
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
