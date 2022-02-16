import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_download/constants/appConstant.dart';

Directory dir = Directory('/storage/emulated/0/EasyDownload/Facebook');
Directory thumbDir = Directory('/storage/emulated/0/.easydownload/.thumbs');

class FacebookGallery extends StatefulWidget {
  const FacebookGallery({Key? key}) : super(key: key);

  @override
  _FacebookGalleryState createState() => _FacebookGalleryState();
}

class _FacebookGalleryState extends State<FacebookGallery> {
  final List<bool> _isImage = [];

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
  void initState() {
    super.initState();
    if (dir.existsSync()) {
      _checkType();
    }
  }

  @override
  Widget build(BuildContext context) {
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
        return Container(
          padding: const EdgeInsets.only(bottom: 150.0),
          margin: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: GridView.builder(
            itemCount: fileList.length,
            itemBuilder: (context, index) {
              File file = fileList[index] as File;
              if (_isImage[index] == false) {
                String thumb = fileList[index].toString().replaceAll('File: \'/storage/emulated/0/EasyDownload/Facebook/', '');
                thumb = thumb.substring(0, thumb.length - 4) + 'jpg';
                var path = thumbDir.path + '/' + thumb;
                file = File(path);
              }
              return Column(
                children: <Widget>[
                  _isImage[index]
                      ? Container(
                          height: screenWidthSize(120, context),
                          width: screenWidthSize(120, context),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Image.file(
                            file,
                            fit: BoxFit.fitWidth,
                          ),
                        )
                      : Stack(
                          children: <Widget>[
                            Container(
                              height: screenWidthSize(120, context),
                              width: screenWidthSize(120, context),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Image.file(
                                file,
                                fit: BoxFit.fitWidth,
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
                        )
                ],
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 0.9,
            ),
          ),
        );
      } else {
        return Scaffold(
          body: Center(
            child: new Container(
                padding: EdgeInsets.only(bottom: 60.0),
                child: Text(
                  'Sorry, No Downloads Found!',
                  style: TextStyle(fontSize: 18.0),
                )),
          ),
        );
      }
    }
  }
}
