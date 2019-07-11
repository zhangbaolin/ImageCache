import 'package:flutter/material.dart';
import 'package:imagecachedemo/CacheFileImage.dart';

import 'package:imagecachedemo/network_image.dart' as network;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url =
      'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1557203777988&di=f5f8b7b33ac12e6509063d7f060c182b&imgtype=0&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F0608a1494f5f2443b42247639745d0951c70b3db3b28b-bxb1eG_fw658';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('三级缓存测试'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image(
                image: network.NetworkImage(url),
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
              ),
            ),
            MaterialButton(
              onPressed: () {
                CacheFileImage _cacheFileImage = CacheFileImage();
                _cacheFileImage.clearCache();
              },
              minWidth: 200,
              height: 50,
              color: Colors.lightBlue,
              child: Text('清除缓存'),
            )
          ],
        ),
      ),
    );
  }
}
