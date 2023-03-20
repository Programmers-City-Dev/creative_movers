import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

typedef ThumbnailBuilder = Widget Function(
    BuildContext context, Uint8List image);

class VideoThumnailBuilder extends StatefulWidget {
  final ThumbnailBuilder builder;
  final String videoUrl;
  const VideoThumnailBuilder(
      {Key? key, required this.builder, required this.videoUrl})
      : super(key: key);

  @override
  State<VideoThumnailBuilder> createState() => _VideoThumnailBuilderState();
}

class _VideoThumnailBuilderState extends State<VideoThumnailBuilder> {
  late final Future<Uint8List?> _thumnailFuture;
  @override
  void initState() {
    super.initState();
    _thumnailFuture = _fetchThumbnail(widget.videoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
        future: _thumnailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return widget.builder.call(context, snapshot.data!);
            }
          }
          return Container();
        });
  }

  Future<Uint8List?> _fetchThumbnail(String videoUrl) async {
    // Fetch thumbnail from api
    Dio dio = Dio();
    try {
      var response = await dio.get(
          "https://video-thumbnail-extractor.p.rapidapi.com/api/v1/"
          "rapid/capivideothumbnailextractor",
          options: Options(responseType: ResponseType.bytes, headers: {
            "content-type": "image/png",
            "X-RapidAPI-Key":
                "62a3289a18mshae4f62227441f27p1e1607jsn952d6b5a04ca",
            "X-RapidAPI-Host": "video-thumbnail-extractor.p.rapidapi.com"
          }),
          queryParameters: {'videoUrl': videoUrl});
      return response.data;
    } on DioError catch (e) {
      log("Error: ${e.message}");
      rethrow;
    }
  }
}
