import 'dart:io';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:easy_download/constants/appConstant.dart';
import 'package:easy_download/screens/youtubeDownload/youtubeData.dart';

Directory dir = Directory('/storage/emulated/0/EasyDownload/Youtube');
Directory thumbDir = Directory('/storage/emulated/0/.easydownload/.thumbs');

class YoutubeDownload extends StatefulWidget {
  const YoutubeDownload({Key? key}) : super(key: key);

  @override
  _YoutubeDownloadState createState() => _YoutubeDownloadState();
}

class _YoutubeDownloadState extends State<YoutubeDownload> with TickerProviderStateMixin {
  final _ytScaffoldKey = GlobalKey<ScaffoldState>();
  late YoutubeChannel  _ytChannel;
  final TextEditingController _urlController = TextEditingController();
   bool _isDisabled = true, _showData = false, _notFirst = false, _isPrivate = false, _hasAudio = false;

  void _download(downloadUrl, name) async {
    await FlutterDownloader.enqueue(
      url: downloadUrl,
      savedDir: dir.path,
      fileName: name,
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  void _getList(String type, YoutubeVideo data) async {
    String details = '';
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: screenHeightSize(225, context),
            child: ListView.builder(
                itemCount: type == 'audio' ? data.audioInfo!.length : data.videoInfo!.length,
                itemBuilder: (context, index) {
                  details = type == 'audio' ? data.audioInfo![index].audioBitrate.toString() + ' kbps' : data.videoInfo![index].videoQuality.toString() + (data.videoInfo![index].hasAudio! ? '' : '[ONLY VIDEO]');
                  return ListTile(
                    onTap: () async {
                      String url = type == 'audio' ? data.audioInfo![index].audioUrl.toString() : data.videoInfo![index].videoUrl.toString();
                      // _downloadDialog(context, url, data.title + ' $details');
                      String info = type == 'audio' ? data.audioInfo![index].audioBitrate.toString() + ' kbps' : data.videoInfo![index].videoQuality.toString() + (data.videoInfo![index].hasAudio! ? '' : '[ONLY VIDEO]');
                      String filename = data.title! + ' - $info' + '.${type == 'audio' ? 'mp3' : 'mp4'}';
                      _download(url, filename);
                      Navigator.of(context).pop();
                    },
                    title: Text(data.title! + ' - $details'),
                  );
                }),
          );
        });
  }

  bool validateURL(List<String> urls) {
    String pattern = r'^(http(s)?:\/\/)?((w){3}.)?youtu(be|.be)?(\.com)?\/.+$';
    RegExp regex =  RegExp(pattern);

    for (var url in urls) {
      if (!regex.hasMatch(url)) {
        return false;
      }
    }
    return true;
  }

  void getButton(String url) {
    if (validateURL([url])) {
      setState(() {
        _isDisabled = false;
      });
    } else {
      setState(() {
        _isDisabled = true;
      });
    }
  }

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
      key: _ytScaffoldKey,
      appBar: PreferredSize(preferredSize: const Size.fromHeight(50),
      child: screenAppBar("Youtube Downloader")),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/youtubeLogo.png",
                  scale: 5.0,
                ),
                const Text(
                  ' Youtube\n   Dowloader',
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
                        'assets/images/youtubeLogo.png',
                        scale: 14.0,
                      ),
                    ),
                    hintText: 'https://www.youtube.com/watch?v=...'),
                onChanged: (value) {
                  getButton(value);
                },
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
                    setState(() {
                      getButton(result['text'].toString());
                    });
                  },
                ),
                _isDisabled
                    ? MyButton(
                        text: 'Download',
                        onPressed: (){},
                      )
                    : MyButton(
                        text: 'Download',
                        onPressed: () async {


                          // try {
                          //   var video = await yt.videos.get(e);
                          //   setState(() {
                          //     valid = true;
                          //     _title = video.title;
                          //     _author = video.author;
                          //     _uploadDate =
                          //     "${video.uploadDate!.day}/${video.uploadDate!.month}/${video.uploadDate!.year}";
                          //     _thumbnail = video.thumbnails.standardResUrl;
                          //     disabled = false;
                          //   });
                          // } on ArgumentError {
                          //   setState(() {
                          //     valid = false;
                          //     disabled = true;
                          //     _title = "Invalid URL";
                          //     _author = "Invalid URL";
                          //     _uploadDate = "Invalid URL";
                          //     _thumbnail =
                          //     "https://upload.wikimedia.org/wikipedia/commons/8/89/HD_transparent_picture.png";
                          //   });
                          // } on VideoUnavailableException {
                          //   setState(() {
                          //     valid = false;
                          //     disabled = true;
                          //     _title = "Invalid URL";
                          //     _author = "Invalid URL";
                          //     _uploadDate = "Invalid URL";
                          //     _thumbnail =
                          //     "https://upload.wikimedia.org/wikipedia/commons/8/89/HD_transparent_picture.png";
                          //   });
                          // }
                          // yt.close();

                          var connectivityResult = await Connectivity().checkConnectivity();
                          if (connectivityResult == ConnectivityResult.none) {
                            _ytScaffoldKey.currentState!.showSnackBar(mySnackBar(context, 'No Internet') as SnackBar);
                            return;
                          }
    //                       var yt = YoutubeExplode();
    //                       try{
    //                         var video = await yt.videos.get(e);
    //                         setState(() {
    //                           _notFirst = true;
    //                           _showData = true;
    //                           _ytChannel = video;
    //                         });
    //                       } on ArgumentError{
    //                         _ytScaffoldKey.currentState!.showSnackBar(mySnackBar(context, 'Check your Url and Try Again!..') as SnackBar);
    //                         setState(() {
    //                           _notFirst = false;
    //                           _showData = false;
    //                         });
    //                       } on VideoUnavailableException{
    // _ytScaffoldKey.currentState!.showSnackBar(mySnackBar(context, 'Video Unavailable!..') as SnackBar);
    // }

                          _ytChannel = await YoutubeData.videoFromUrl(_urlController.text);
                          if (_ytChannel.videoData!.videoInfo![0].videoUrl!.length == 4) {
                            _ytScaffoldKey.currentState!.showSnackBar(mySnackBar(context, 'Check your Url and Try Again!..') as SnackBar);
                            setState(() {
                              _notFirst = false;
                            });
                            return;
                          }
                          if (_ytChannel.videoData!.audioInfo!.isEmpty) {
                            setState(() {
                              _hasAudio = false;
                            });
                          } else {
                            setState(() {
                              _hasAudio = true;
                            });
                          }
                          setState(() {
                            _showData = true;
                          });
                          // _getDownloadLink();
                        },
                      ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            _isPrivate
                ? const Text(
                    'This Video is Private',
                    style: TextStyle(fontSize: 14.0),
                  )
                : Container(),
            _notFirst
                ? _showData
                    ? Container(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        margin: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: screenHeightSize(375, context),
                          child: GridView.builder(
                            itemCount: 1,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              String _postDescription = _ytChannel.videoData!.title!;
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
                                          thumbnail: NetworkImage(_ytChannel.videoData!.thumbnail!),
                                          image: NetworkImage(_ytChannel.videoData!.thumbnail!),
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
                                        '${_postDescription.length > 100 ? _postDescription.replaceRange(100, _postDescription.length, '') : _postDescription}...',
                                        style: const TextStyle(fontSize: 14.0),
                                      ),
                                      onTap: () async {
                                        Clipboard.setData(ClipboardData(text: _postDescription));
                                        _ytScaffoldKey.currentState!.showSnackBar(mySnackBar(context, 'Caption Copied') as SnackBar);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: MyButton(
                                      text: 'Download Thumbnail',
                                      padding: const EdgeInsets.all(5.0),
                                      color: Theme.of(context).accentColor,
                                      // onPressed: _isDown
                                      //     ? null
                                      //     : () async {
                                      //         var _downloadUrl = _ytChannel.videoData.thumbnail;
                                      //         _downloadDialog(context, _downloadUrl, _ytChannel.videoData.title);
                                      //       },
                                      onPressed: () async {
                                        _ytScaffoldKey.currentState!.showSnackBar(mySnackBar(context, 'Added to Download') as SnackBar);
                                        String downloadUrl = _ytChannel.videoData!.thumbnail!;
                                        String name = 'YT-Thumbnail-${_ytChannel.videoData!.title}.png';
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: MyButton(
                                          text: 'Download Audio',
                                          padding: const EdgeInsets.all(5.0),
                                          color: Theme.of(context).accentColor,
                                          onPressed: _hasAudio
                                              ? () async {
                                                  _getList('audio', _ytChannel.videoData!);
                                                }
                                              : (){},
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0),
                                        child: MyButton(
                                          text: 'Download Video',
                                          padding: const EdgeInsets.all(5.0),
                                          color: Theme.of(context).accentColor,
                                          onPressed: () async {
                                            String downloadUrl = _ytChannel.videoData!.thumbnail!;
                                            String name = '${_ytChannel.videoData!.title}.png';
                                            //save video thumbnail
                                            await FlutterDownloader.enqueue(
                                              url: downloadUrl,
                                              savedDir: thumbDir.path,
                                              fileName: name,
                                              showNotification: false,
                                            );
                                            _getList('video', _ytChannel.videoData!);
                                          },
                                        ),
                                      ),
                                    ],
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
                    : const SizedBox(
                        height: 100,
                        child: Center(
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
