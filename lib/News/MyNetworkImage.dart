import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui show Codec;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class MyNetworkImage extends ImageProvider<MyNetworkImage> {
  /// Creates an object that fetches the image at the given URL.
  ///
  /// The arguments must not be null.
  ///
  const MyNetworkImage(this.url, {this.sdCache = 1.0, this.headers})
      : assert(url != null),
        assert(sdCache != null);

  /// The URL from which the image will be fetched.
  final String url;

  /// The scale to place in the [ImageInfo] object of the image.
  final double sdCache;

  /// The HTTP headers that will be used with [HttpClient.get] to fetch image from network.
  final Map<String, String> headers;

  @override
  Future<MyNetworkImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<MyNetworkImage>(this);
  }

  @override
  ImageStreamCompleter load(MyNetworkImage key) {
    return MultiFrameImageStreamCompleter(
        codec: _loadAsync(key),
        scale: key.sdCache,
        informationCollector: (StringBuffer information) {
          information.writeln('Image provider: $this');
          information.write('Image key: $key');
        });
  }

  Future<ui.Codec> _loadAsync(MyNetworkImage key) async {
    assert(key == this);
    //本地已经缓存过就直接返回图片
    if (sdCache != null) {
      final Uint8List bytes = await _getFromSdcard(key.url);
      if (bytes != null &&
          bytes.lengthInBytes != null &&
          bytes.lengthInBytes != 0) {
        print("从本地拿走");
        return await PaintingBinding.instance.instantiateImageCodec(bytes);
      }
    }
    final Uri resolved = Uri.base.resolve(key.url);
    http.Response response = await http.get(resolved);

    if (response.statusCode != HttpStatus.ok)
      throw Exception(
          'HTTP request failed, statusCode: ${response?.statusCode}, $resolved');

    final Uint8List bytes = await response.bodyBytes;
//网络请求结束后缓存图片到本地
    if (sdCache != null && bytes.lengthInBytes != 0) {
      print("存起来了");
      _saveToImage(bytes, key.url);
    }
    if (bytes.lengthInBytes == 0)
      throw Exception('MyNetworkImage is an empty file: $resolved');

    return await PaintingBinding.instance.instantiateImageCodec(bytes);
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final MyNetworkImage typedOther = other;
    return url == typedOther.url && sdCache == typedOther.sdCache;
  }

  @override
  int get hashCode => hashValues(url, sdCache);

  @override
  String toString() => '$runtimeType("$url", scale: $sdCache)';

//图片路径MD5一下 缓存到本地
  void _saveToImage(Uint8List mUint8List, String name) async {
    name = md5.convert(utf8.encode(name)).toString();
    Directory dir = await getTemporaryDirectory();
    String path = dir.path + "/" + name;
    var file = File(path);
    bool exist = await file.exists();
    print("path =${path}");
    if (!exist) File(path).writeAsBytesSync(mUint8List);
  }

  _getFromSdcard(String name) async {
    name = md5.convert(utf8.encode(name)).toString();
    Directory dir = await getTemporaryDirectory();
    String path = dir.path + "/" + name;
    var file = File(path);
    bool exist = await file.exists();
    if (exist) {
      final Uint8List bytes = await file.readAsBytes();
      return bytes;
    }
    return null;
  }
}
