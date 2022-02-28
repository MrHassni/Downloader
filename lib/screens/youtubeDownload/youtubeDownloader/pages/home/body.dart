
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../../../../constants/appConstant.dart';
import '../../pages/results/results.dart';

import '../../utils/const.dart';

/// most download page
class MyBody extends StatefulWidget {
  const MyBody({Key? key}) : super(key: key);

  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  final String _myTitle = 'Search Video';
final TextEditingController _urlController = TextEditingController();

  /// hislks
  final SearchTo _st = SearchTo.video;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/youtubeLogo.png",
                scale: 1.0,
              ),
              const Text(
                ' YouTube\n   Downloader',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Text('Search or Paste The Link Here'),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                child: TextField(
                  maxLines: 1,
                  controller: _urlController,
                  decoration: InputDecoration(
                    prefixIcon: InkWell(
                      child: Image.asset(
                        'assets/images/youtubeLogo.png',
                        scale: 5.0,
                      ),
                    ),

                    enabledBorder:OutlineInputBorder(
                      borderSide:  BorderSide(color: Theme.of(context).primaryColorLight, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide:  BorderSide(color: Theme.of(context).primaryColorLight, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: _myTitle,
                  ),

                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                      text: 'Search',
                      onPressed: (){
                    if (_urlController.text.isNotEmpty) {
                      Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>ShowingResult(query: _urlController.text, st: _st, isDispoQuery: isDispo.yes,)));
                    }
                  }),
                ],
              ),

              // SizedBox(
              //   width: MediaQuery.of(context).size.width * 0.4,
              //   child: MaterialButton(
              //     color: Theme.of(context).primaryColorDark,
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 10,
              //       vertical: 15,
              //     ),
              //     onPressed: () {
              //       if (val.isNotEmpty) {
              //         Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>ShowingResult(query: val, st: _st, isDispoQuery: isDispo.yes,)));
              //       }
              //     },
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: const <Widget>[
              //         Icon(
              //           Icons.search,
              //           size: 20,
              //           color: Colors.white,
              //         ),
              //         SizedBox(width: 5),
              //         Text(
              //           'Search',
              //         ),
              //       ],
              //     ),
              //   ),
              // )
            ],
          )
        ],
      ),
    );
  }
}
