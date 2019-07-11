import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

class CacheFileImage {
  /// 判断是否有对应图片缓存文件存在
  Future<Uint8List> getFileBytes(String url) async {
    String cacheDirPath = await getCachePath();
    String urlMd5 = getUrlMd5(url);
    File file = File("$cacheDirPath/$urlMd5");
    print("读取文件:${file.path}");
    if (file.existsSync()) {
      return await file.readAsBytes();
    }

    return null;
  }

  /// 获取url字符串的MD5值
  static String getUrlMd5(String url) {
    var content = new Utf8Encoder().convert(url);
    var digest = md5.convert(content);
    return digest.toString();
  }

  /// 获取图片缓存路径
  Future<String> getCachePath() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Directory cachePath = Directory("${dir.path}/imagecaches/");
    if (!cachePath.existsSync()) {
      cachePath.createSync();
    }
    return cachePath.path;
  }

  /// 将下载的图片数据缓存到指定文件
  Future saveBytesToFile(String url, Uint8List bytes) async {
    String cacheDirPath = await getCachePath();
    String urlMd5 = getUrlMd5(url);
    File file = File("$cacheDirPath/$urlMd5");
    if (file != null) {
      print('图片的缓存目录：${file.path}');
    }

    if (!file.existsSync()) {
      file.createSync();
      await file.writeAsBytes(bytes);
    }
  }

  void clearCache() async {
    //此处展示加载loading
    try {
      Directory tempDir = await getApplicationDocumentsDirectory();

      await delDir(tempDir);
    } catch (e) {
      print(e);
    } finally {
      //此处隐藏加载loading
    }
  }

  ///递归方式删除目录
  Future<Null> delDir(FileSystemEntity file) async {
    try {
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await delDir(child);
        }
      }
      await file.delete();
      print('清除缓存成功');
    } catch (e) {
      print(e);
    }
  }
}
