import 'dart:convert';

import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:creative_movers/models/deep_link_data.dart';

import 'deep_link_repository.dart';

class DeepLinkRepoImpl extends DeepLinkRepo {
  final String key = StorageKeys.pushNotification;

  @override
  Future<void> deleteRecentNotification() async {
    StorageHelper.remove(key);
  }

  @override
  Future<DeepLinkData?> getRecentNotification() async {
    final recentPushNotif = await StorageHelper.getString(key);
    if (recentPushNotif != null) {
      final map = json.decode(recentPushNotif);
      return DeepLinkData.fromMap(map);
    }
    return null;
  }

  @override
  Future<void> saveRecentNotification(DeepLinkData notification) async {
    StorageHelper.setString(key, json.encode(notification.toMap()));
  }
}
