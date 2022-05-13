import 'dart:developer';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:native_linkify/native_linkify.dart';

class LinkPreview extends StatefulWidget {
  final String text;

  const LinkPreview({Key? key, required this.text}) : super(key: key);

  @override
  State<LinkPreview> createState() => _LinkPreviewState();
}

class _LinkPreviewState extends State<LinkPreview> {
  List<String> urls = [];

  @override
  void initState() {
    super.initState();
    _detectUrls(widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return urls.isEmpty
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: AnyLinkPreview(
              link: urls.first,
              displayDirection: uiDirection.uiDirectionHorizontal,
              showMultimedia: true,
              bodyMaxLines: 3,
              titleStyle: const TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              bodyStyle:
                  const TextStyle(color: AppColors.textColor, fontSize: 12),
              errorBody: '',
              errorTitle: '',
              errorWidget: const SizedBox.shrink(),
              errorImage: '',
              placeholderWidget: const SizedBox.shrink(),
              cache: const Duration(days: 7),
              backgroundColor: Colors.grey[100],
              borderRadius: 12,
              removeElevation: true,
              boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.grey)],
              onTap: () {
                AppUtils.launchInAppBrowser(context, urls.first);
              }, // This disables tap event
            ),
          );
  }

  void _detectUrls(String text) async {
    if (text.isNotEmpty) {
      try {
        final entries = await NativeLinkify.linkify(text);
        if (entries.isNotEmpty) {
          for (final l in entries) {
            if (l is LinkifyUrl) {
              urls.add(l.url);
            }
          }
          setState(() {});
        }
      } catch (e) {
        log("Error generating links: $e");
      }
    }
  }
}
