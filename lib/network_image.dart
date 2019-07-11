import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui' as ui show Codec;
import 'package:flutter/foundation.dart';
import 'package:imagecachedemo/CacheFileImage.dart';

class NetworkImage extends ImageProvider<NetworkImage> {
  /// Creates an object that fetches the image at the given URL.
  ///
  /// The arguments must not be null.
  ///
  const NetworkImage(this.url, {this.scale = 1.0, this.headers})
      : assert(url != null),
        assert(scale != null);
  static final CacheFileImage _cacheFileImage = CacheFileImage();

  /// The URL from which the image will be fetched.
  final String url;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;

  /// The HTTP headers that will be used with [HttpClient.get] to fetch image from network.
  final Map<String, String> headers;

  @override
  Future<NetworkImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<NetworkImage>(this);
  }

  @override
  ImageStreamCompleter load(NetworkImage key) {
    return MultiFrameImageStreamCompleter(
        codec: _loadAsync(key),
        scale: key.scale,
        informationCollector: (StringBuffer information) {
          information.writeln('Image provider: $this');
          information.write('Image key: $key');
        });
  }

  static final HttpClient _httpClient = HttpClient();

  Future<ui.Codec> _loadAsync(NetworkImage key) async {
    assert(key == this);

    /// 新增代码块start
    /// 从缓存目录中查找图片是否存在
    final Uint8List cacheBytes = await _cacheFileImage.getFileBytes(key.url);
    if (cacheBytes != null) {
      print('我是旧的');
      return PaintingBinding.instance.instantiateImageCodec(cacheBytes);
    }

    /// 新增代码块end
    ///
    final Uri resolved = Uri.base.resolve(key.url);
    final HttpClientRequest request = await _httpClient.getUrl(resolved);
    headers?.forEach((String name, String value) {
      request.headers.add(name, value);
    });
    final HttpClientResponse response = await request.close();
    if (response.statusCode != HttpStatus.ok)
      throw Exception(
          'HTTP request failed, statusCode: ${response?.statusCode}, $resolved');

    final Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    if (bytes.lengthInBytes == 0)
      throw Exception('NetworkImage is an empty file: $resolved');

    /// 新增代码块start
    /// 将下载的图片数据保存到指定缓存文件中
    await _cacheFileImage.saveBytesToFile(key.url, bytes);
    print('新添加的');

    /// 新增代码块end
    return PaintingBinding.instance.instantiateImageCodec(bytes);
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final NetworkImage typedOther = other;
    return url == typedOther.url && scale == typedOther.scale;
  }

  @override
  int get hashCode => hashValues(url, scale);

  @override
  String toString() => '$runtimeType("$url", scale: $scale)';
}
