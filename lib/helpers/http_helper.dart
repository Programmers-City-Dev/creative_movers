import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class HttpHelper {
  static Dio? _client;

  static Future<Dio?> _getInstance([bool enabledDioLogger = false]) async {
    final storageToken = await StorageHelper.getString(StorageKeys.token);
    // debugPrint('TOKEN:$storageToken');
    _client ??= Dio();

    Map<String, dynamic> headers = {};
    headers['Content-Type'] = 'application/json';
    headers['Accept'] = 'application/json';
    if (storageToken != null) headers['Authorization'] = 'Bearer $storageToken';

    _client!.options.headers = headers;
    if (enabledDioLogger) {
      // _client!.interceptors.add(
      //   PrettyDioLogger(
      //     request: false,
      //     requestHeader: false,
      //     requestBody: false,
      //     responseBody: false,
      //     responseHeader: false,
      //     error: true,
      //     compact: true,
      //     maxWidth: 400,
      //   ),
      // );
    }
    return _client;
  }

  Future<Response> get(String url, {Options? options}) async {
    final instance = await _getInstance();
    return instance!.get(url, options: options);
  }

  Future<Response> download(String url, String savePath,
      {required ProgressCallback progressCallback}) async {
    final instance = await _getInstance();
    return instance!
        .download(url, savePath, onReceiveProgress: progressCallback);
  }

  Future<Response> post(String url,
      {dynamic body,
      ProgressCallback? progressCallback,
      Options? options}) async {
    final instance = await _getInstance(true);
    return instance!.post(url,
        data: body, onSendProgress: progressCallback, options: options);
  }

  Future<Response> put(String url, {dynamic body}) async {
    final instance = await _getInstance();
    return instance!.put(url, data: body);
  }

  Future<Response> patch(String url, {dynamic body}) async {
    final instance = await _getInstance();
    return instance!.patch(url, data: body);
  }

  Future<Response> delete(String url, {dynamic body}) async {
    final instance = await _getInstance();
    return instance!.delete(url);
  }
}
