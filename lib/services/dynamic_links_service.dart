import 'dart:developer';

import 'package:creative_movers/blocs/deep_link/deep_link_cubit.dart';
import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/data/remote/model/feeds_response.dart';
import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:creative_movers/models/deep_link_data.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DynamicLinksService {
  static bool isInitialized = false;
  DynamicLinksService._();

  static init() async {
    // Get any initial links
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      // Example of using the dynamic link to push the user to a different screen
      log('INITIAL LINK: ${deepLink.data}');
      decodeAndNavigateLink(initialLink);
    }

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      decodeAndNavigateLink(dynamicLinkData);
    }).onError((error) {
      log("ON-LINK ERROR: $error");
    });
  }

  static void decodeAndNavigateLink(
      PendingDynamicLinkData dynamicLinkData) async {
    // log("ON-LINK: ${dynamicLinkData.link.queryParameters}");
    // log("ON-LINK: ${dynamicLinkData.link}");
    // var pathSegments = dynamicLinkData.link.pathSegments;
    bool isLoggedIn =
        await StorageHelper.getBoolean(StorageKeys.stayLoggedIn, false);
    var link = dynamicLinkData.link;
    if (link.pathSegments.contains("feed")) {
      log("LINK: $link");
      if (isLoggedIn) {
        var queryParameters = dynamicLinkData.link.queryParameters;
        if (queryParameters.isNotEmpty) {
          var feedId = queryParameters["id"];
          injector.get<DeepLinkCubit>().saveRecentNotification(DeepLinkData(
              type: "feed", id: int.parse(feedId ?? "0"), path: "feed"));
        }
      } else {
        log("PLEASE LOGIN FIRST");
      }
    } else if (link.pathSegments.contains("profile")) {
      log("LINK: $link");
      if (isLoggedIn) {
        var queryParameters = dynamicLinkData.link.queryParameters;
        if (queryParameters.isNotEmpty) {
          var userId = queryParameters["id"];
          injector.get<DeepLinkCubit>().saveRecentNotification(DeepLinkData(
              type: "profile", id: int.parse(userId ?? "0"), path: "profile"));
        }
      } else {
        log("PLEASE LOGIN FIRST");
      }
    }
  }

  static Future<String> createFeedDeepLink(Feed feed) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://creativemovers.page.link/feed?id=${feed.id}"),
      uriPrefix: "https://creativemovers.page.link",
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: (feed.media.isNotEmpty && feed.media.first.type == "image")
            ? Uri.parse(
                // "https://play-lh.googleusercontent.com/jsYfFIeMa5IRFgVLbAEzT-V9JpO7aLw_q03kD5lY3FzEo-bbWy0jbYOvcXjK-uiLhg=w832-h470-rw"
                feed.media.first.mediaPath)
            : Uri.parse(""),
        title: 'CreativeMovers - Business Social Network',
      ),
      androidParameters:
          AndroidParameters(packageName: packageInfo.packageName),
      iosParameters: IOSParameters(
          bundleId: packageInfo.packageName, appStoreId: "6444662400"),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    // log("Package name: $username");
    return dynamicLink.shortUrl.toString();
  }

  static Future<String> createProfileDeepLink(User user) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://creativemovers.page.link/profile?id=${user.id}"),
      uriPrefix: "https://creativemovers.page.link",
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: Uri.parse(user.profilePhotoPath ?? ''),
        title: '${user.firstname} ${user.lastname}',
      ),
      androidParameters:
          AndroidParameters(packageName: packageInfo.packageName),
      iosParameters: IOSParameters(
          bundleId: packageInfo.packageName, appStoreId: "6444662400"),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    // log("Package name: $username");
    return dynamicLink.shortUrl.toString();
  }
}
