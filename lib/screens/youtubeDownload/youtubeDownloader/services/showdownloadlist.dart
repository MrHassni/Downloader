import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/ytmodel.dart';
import '../services/provider/ytprovider.dart';
import '../utils/audio.dart';
import '../utils/const.dart';
import '../utils/fullvid.dart';
import '../utils/onlyvid.dart';

/// show download listo
void showDownloadListo(
  BuildContext context,
  String title,
  VideoId id,
  String thumbLow,
  String thumbMid,
  String thumbHigh,
  // String thumb4,
) {

  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext builder) {
      return ListView(
        physics: const ClampingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'Full-Videos',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ),
          fullvidWidgets(id, context, thumbMid, title),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'Only Audio',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ),
          audioWidgets(id, context, thumbMid, title),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'Only Video',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ),
          videoWidgets(id, context, thumbMid, title),
          Padding(
            /* padding: const EdgeInsets.all(8.0), */
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'Thumbnails',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            children: <Widget>[
              MaterialButton(
                onPressed: () {
                  /// 1st-> get storage permission
                  /// 2nd-> get download path
                  /// 3rd-> download the file
                  Provider.of<YoutubeDownloadProvider>(context, listen: false)
                      .addThumbnail(
                    YoutubeDownloadModel(
                      thumbHigh,
                      title,
                      'High',
                      '',
                      thumbHigh,
                      id,
                      TypeDownload.thumbnail,
                    ),
                  );
                  Navigator.pop(context);
                },

                padding: const EdgeInsets.all(10),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const <Widget>[
                    Text('High  '),
                  ],
                ),
              ),
             MaterialButton(
                onPressed: () {
                  Provider.of<YoutubeDownloadProvider>(context, listen: false)
                      .addThumbnail(
                    YoutubeDownloadModel(
                      thumbMid,
                      title,
                      'Medium',
                      '',
                      thumbMid,
                      id,
                      TypeDownload.thumbnail,
                    ),
                  );
                  Navigator.pop(context);
                },
                /* margin: const EdgeInsets.all(30), */

                padding: const EdgeInsets.all(10),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const <Widget>[
                    Text('Medium'),
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Provider.of<YoutubeDownloadProvider>(context, listen: false)
                      .addThumbnail(
                    YoutubeDownloadModel(
                      thumbLow,
                      title,
                      'Law',
                      '',
                      thumbLow,
                      id,
                      TypeDownload.thumbnail,
                    ),
                  );
                  Navigator.pop(context);
                },
                /* margin: const EdgeInsets.all(30), */
                padding: const EdgeInsets.all(10),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const <Widget>[
                    Text('Low   '),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
