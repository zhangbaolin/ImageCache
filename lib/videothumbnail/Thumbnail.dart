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

  getTh(){
    final uint8list = await VideoThumbnail.thumbnailFile(
  video: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
  thumbnailPath: (await getTemporaryDirectory()).path,
  imageFormat: ImageFormat.WEBP,
  maxHeightOrWidth: 0, // the original resolution of the video
  quality: 75,
);
  }
}
