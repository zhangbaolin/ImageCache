import 'package:flutter/material.dart';

class APPBarTestPage extends StatefulWidget {
  @override
  _APPBarTestPageState createState() => _APPBarTestPageState();
}

class _APPBarTestPageState extends State<APPBarTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, //把appbar的背景色改成透明
        // elevation: 0,//appbar的阴影
        title: Text('123456'),
      ),
    );
  }
}
