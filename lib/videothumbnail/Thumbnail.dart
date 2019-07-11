import 'package:flutter/material.dart';


class Thumbnail extends StatefulWidget {
  @override
  _ThumbnailState createState() => _ThumbnailState();
}

class _ThumbnailState extends State<Thumbnail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('asdsadas'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Image(
                image: AssetImage('lib/images/girl.png'),
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
              MaterialButton(
                onPressed: () {},
                minWidth: 200,
                child: Text('获取缩测图'),
                height: 50,
                color: Colors.lightBlue,
              )
            ],
          ),
        ),
      ),
    );
  } 


}
