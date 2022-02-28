

import 'package:flutter/material.dart';

double screenHeightSize(double size, BuildContext context) {
  return size * MediaQuery.of(context).size.height / 650.0;
}

double screenWidthSize(double size, BuildContext context) {
  return size * MediaQuery.of(context).size.width / 400.0;
}

Widget screenAppBar(String screenName) {
  return AppBar(
    leading: Container(),
    title: Text(
      screenName,
      style: const TextStyle(
        fontFamily: 'Billabong',
        fontSize: 34,color: Colors.white
      ),
    ),
    backgroundColor:Colors.purple,
    elevation: 0,
  );
}

Widget mySnackBar(BuildContext context, String msg) {
  return SnackBar(
    content: Text(msg),
    backgroundColor: Theme.of(context).primaryColorDark,
    duration: const Duration(seconds: 4),
  );
}

class MyButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const MyButton(
      {Key? key, this.text, required this.onPressed, this.color, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: (color != null) ? color : Theme.of(context).primaryColor,
      highlightColor: Theme.of(context).accentColor,
      disabledColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: (padding != null)
            ? padding as EdgeInsetsGeometry
            : const EdgeInsets.all(15.0),
        child:
            FittedBox(child: Text((text != null) ? text.toString() : "Button",style: const TextStyle(
              color: Colors.white
            ),)),
      ),
      onPressed: onPressed,
    );
  }
}
