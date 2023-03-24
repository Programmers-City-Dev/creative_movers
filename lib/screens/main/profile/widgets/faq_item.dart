import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../data/remote/model/FaqsResponse.dart';

class FaqItem extends StatefulWidget {
  const FaqItem({Key? key, required this.index, required this.faq})
      : super(key: key);
  final int index;
  final Faq faq;

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  bool visible = true;
  late double widgetHeight;
  final _sizedBoxKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widgetHeight = _sizedBoxKey.currentContext!.size!.height;
      log(_sizedBoxKey.currentContext!.size!.height.toString());
    });
    super.initState();
  }

  final textStyle = const TextStyle(
    fontSize: 13,
    color: Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // log('${ _sizedBoxKey.currentState?.context.size?.height}');
          visible = !visible;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   width: 50,
            //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            //   decoration: BoxDecoration(
            //       color: Theme.of(context).colorScheme.primary,
            //       borderRadius: BorderRadius.circular(8)),
            //   child: Center(
            //       child: Text(
            //     widget.index.toString(),
            //     style: const TextStyle(
            //         color: Colors.white,
            //         fontSize: 18,
            //         fontWeight: FontWeight.bold),
            //   )),
            // ),
            // const SizedBox(
            //   width: 16,
            // ),
            Expanded(
              child: ExpansionTile(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  tilePadding: EdgeInsets.zero,
                  title: Text(
                    widget.faq.question,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  children: [
                    // Text(widget.faq.answer),
                    Html(
                      data: widget.faq.answer,
                      style: {
                        "p": Style(
                          fontSize: FontSize(23),
                        ),
                      },
                    ),
                    // Text(
                    //   widget.faq.answer,
                    //   key: _sizedBoxKey,
                    //   style: textStyle,
                    // )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
