/* import 'package:flutter/cupertino.dart'; */
/* import 'package:flutter/material.dart'; */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/ytmodel.dart';
import '../services/provider/ytprovider.dart';
import '../utils/const.dart';

/// get audiowidgets
FutureBuilder<List<Widget>> audioWidgets(
  VideoId id,
  BuildContext context,
  String thumbMid,
  String title,
) {
  return FutureBuilder<List<Widget>>(
    future: getAudio(id, context, thumbMid, title),
    // initialData: InitialData,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        /* print('this is snap ${snapshot.data[0]}'); */
        // return snapshot.data[0] as Widget;
        return Wrap(
          children: snapshot.data as List<Widget>,
        );
      } else if (snapshot.hasError) {
        return Column(
          children: <Widget>[
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            )
          ],
        );
      } else {
        return const Padding(
            padding: EdgeInsets.all(50),
            child: Center(child: CircularProgressIndicator()));
      }
    },
  );
}

/// get all audios
Future<List<Widget>> getAudio(
    VideoId id, BuildContext context, String thumbMid, String title) async {
  final YoutubeExplode yt = YoutubeExplode();
  final List<Widget> audwid = <Widget>[];
  final StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
  for (final AudioStreamInfo i in manifest.audioOnly) {
    final List<String> _sp = i.size.toString().split('.');
    final String _f = _sp[0];
    final String _l = _sp[1].substring(0, 2);
    final String _ext = _sp[1].substring(_sp[1].length - 2);
    audwid.add(MaterialButton(
      onPressed: () {
        /* print('pressed only vid shit'); */
        Provider.of<YoutubeDownloadProvider>(context, listen: false).addaudio(
            YoutubeDownloadModel(thumbMid, title, i.audioCodec.toString(),
                'loc', i.url.toString(), id, TypeDownload.audio));
        Navigator.pop(context);
      },

      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(i.audioCodec),
          const Text('|'),
          Text('$_f.$_l $_ext'),
        ],
      ),
    ));
  }
  return audwid;
}
