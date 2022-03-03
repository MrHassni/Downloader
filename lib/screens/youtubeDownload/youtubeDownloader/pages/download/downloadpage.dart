import 'dart:developer';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/appConstant.dart';
import '../../services/provider/ytprovider.dart';
import 'downloadpageitem.dart';


Directory dir = Directory('/storage/emulated/0/EasyDownload/Youtube');

/// shiting page
class YoutubeDownloadPage extends StatefulWidget {
  /// shiting page
  const YoutubeDownloadPage({Key? key}) : super(key: key);

  @override
  State<YoutubeDownloadPage> createState() => _YoutubeDownloadPageState();
}

class _YoutubeDownloadPageState extends State<YoutubeDownloadPage> {

  final List<bool> _isImage = [];

  ChewieController? _chewieController;
  var fileList;
  late final _videoPlayerControllers = List<VideoPlayerController>.empty(growable: true);
  late final _chewieControllers = List<ChewieController>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);

    }
    fileList = dir.listSync();
    getData();
    _checkType();
  }



  @override
  void dispose() {

    for (var element in _videoPlayerControllers) {
      element.dispose();
    }
    _chewieController?.dispose();
    super.dispose();
  }

  getData() async {
    log('        bb       ' + fileList.length.toString());
    for (int i = 0; i < fileList.length; i++) {
      _videoPlayerControllers
          .add(VideoPlayerController.file(File(fileList[i].path))
        ..initialize().then((_) {
          _chewieControllers.add(ChewieController(
              aspectRatio: _videoPlayerControllers[i].value.aspectRatio,
              autoInitialize: true,
              videoPlayerController: _videoPlayerControllers[i],
              autoPlay: false,
              looping: false,
              fullScreenByDefault: false
          ));
          setState(() {});
        }));

    }

    //
  }

  Widget wrapController(VideoPlayerController controller) {
    return controller.value.isInitialized
        ? VideoPlayer(controller)
        : Container();
  }

  void _checkType() {
    for (var item in dir.listSync()) {
      if (item.toString().endsWith(".jpg'")) {
        _isImage.add(true);
      } else {
        _isImage.add(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Provider.of<YoutubeDownloadProvider>(context, listen: false)
                  .totalDownload >
              0
          ? DownloadPageItem(
              context: context,
            )
          : (){
        if (!dir.existsSync()) {
          return const Center(
            child: Text(
              'Sorry, No Downloads Found!',
              style: TextStyle(fontSize: 18.0),
            ),
          );
        } else {
          var fileList = dir.listSync();
          if (fileList.isNotEmpty) {
            return Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        // mainAxisExtent: MediaQuery.of(context).size.width * 0.7,
                          childAspectRatio: 4 / 6,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5, crossAxisCount: 3),
                      itemCount: fileList.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return
                          _isImage[index]
                              ? Container(
                            height: screenWidthSize(120, context),
                            width: screenWidthSize(120, context),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Image.file(
                              fileList[index] as  File,
                              fit: BoxFit.fitWidth,
                            ),
                          )
                              : InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(
                                PageRouteBuilder(
                                  opaque: false,
                                  settings: const RouteSettings(),
                                  pageBuilder: (
                                      BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation,
                                      ) {
                                    return Scaffold(
                                        backgroundColor: Theme.of(context).primaryColorDark,
                                        resizeToAvoidBottomInset: false,
                                        body: SafeArea(
                                          child: Dismissible(
                                              key: const Key('key'),
                                              direction: DismissDirection.vertical,
                                              onDismissed: (_) =>
                                                  Navigator.of(context).pop(),
                                              child: OrientationBuilder(
                                                builder: (context, orientation) {
                                                  return Center(
                                                    child: Stack(
                                                      fit: StackFit.expand,
                                                      children: [
                                                        AspectRatio(
                                                            aspectRatio: _videoPlayerControllers[_isImage.isEmpty ? index :  index + 1 - _isImage.length].value.aspectRatio,
                                                            child: Chewie(controller: _chewieControllers[_isImage.isEmpty ? index :  index + 1 - _isImage.length],)),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              )),
                                        ));
                                  },
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: wrapController(_videoPlayerControllers[index]),
                            ),
                          );
                      }),
                ));
          } else {
            return Center(
                child:  Container(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    child: const Text(
                      'Sorry, No Downloads Found!',
                      style: TextStyle(fontSize: 18.0),
                    )),
              );
          }
        }
      }(),
    );
  }
}
