import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//https://stackoverflow.com/questions/54058228/horizontal-divider-with-text-in-the-middle-in-flutter

class HorizontalTextLine extends StatelessWidget {
  HorizontalTextLine({
    required this.label,
    required this.height,
  });

  String label = "";
  double height = 10;

  @override
  Widget build(BuildContext context) {

    return Row(children: <Widget>[
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 10.0, right: 15.0),
            child: Divider(
              color: Colors.black54,
              height: height,
            )),
      ),

      Text(
        label,
        style: TextStyle(
          color: Colors.black54,
        ),
      ),

      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Divider(
              color: Colors.black54,
              height: height,
            )),
      ),
    ]);
  }
}