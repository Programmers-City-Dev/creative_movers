import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';

class FileDownloaderService {
  static Future<void> init() async {
    // Plugin must be initialized before using
    await FlutterDownloader.initialize(
        debug: true,
        // optional: set to false to disable printing logs to console (default: true)
        ignoreSsl:
            true // option: set to false to disable working with http links (default: false)
        );
  }

  static void prepare(){

  }


  static void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }
}
