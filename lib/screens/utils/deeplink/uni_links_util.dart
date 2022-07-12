import 'package:creative_movers/blocs/deep_link/deep_link_cubit.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/models/deep_link_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:uni_links/uni_links.dart';

class UniLinks {
  UniLinks._();

  static void init() async {
    try {
      final initialUri = await getInitialUri();
      if (initialUri != null) _decodeUri(initialUri);
    } on FormatException {
      debugPrint('error in link');
    } catch (e) {}

    uriLinkStream.listen((Uri? uri) {
      _decodeUri(uri);
    }, onError: (err) {
      debugPrint('error in link');
    });
  }

  static void _decodeUri(Uri? uri) {
    if (uri.toString().endsWith('/')) {
      uri = Uri.parse(uri.toString().substring(0, uri.toString().length - 1));
    }

    String? type;
    int? id;
    String? path;
    if (uri!.origin.contains('community')) {
      type = 'community';
      path = uri.path;
    } else if (uri.origin.contains('patient')) {
      type = uri.pathSegments.first;
      path = uri.pathSegments.sublist(1).join('/');
    }

    id = int.tryParse(uri.pathSegments.last);
    if (id != null && path == '$id') path = null;

    DeepLinkData data = DeepLinkData(type: type, id: id, path: path);
    injector<DeepLinkCubit>().saveRecentNotification(data);
    // DeeplinkAnalyticEvents().appOpenedFromUrl(url: uri);
  }
}
