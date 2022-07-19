import 'package:creative_movers/models/deep_link_data.dart';

abstract class DeepLinkRepo{
  Future<void> saveRecentNotification(DeepLinkData notification);
  Future<DeepLinkData?> getRecentNotification();
  Future<void> deleteRecentNotification();
}