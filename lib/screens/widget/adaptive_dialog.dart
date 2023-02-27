import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Author : Ketan Ramani
// Use : To Show Platform Specific Dialog (Android & iOS)

class AdaptiveDialog extends StatelessWidget {
  final String? title, message, left, right;
  final bool isRedPositive;
  final VoidCallback leftClick, rightClick;

  const AdaptiveDialog(
    this.message,
    this.left,
    this.right,
    this.leftClick,
    this.rightClick, {
    Key? key,
    this.title = '',
    this.isRedPositive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoAlertDialog(
            title: title != ''
                ? Text(
                    title!,
                    style: const TextStyle(color: CupertinoColors.black),
                  )
                : null,
            content: Text(
              message!,
              style: const TextStyle(color: CupertinoColors.black),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: leftClick,
                child: Text(
                  left!,
                  style: const TextStyle(color: CupertinoColors.activeBlue),
                ),
              ),
              CupertinoDialogAction(
                onPressed: rightClick,
                child: Text(
                  right!,
                  style: TextStyle(
                    color: isRedPositive
                        ? CupertinoColors.systemRed
                        : CupertinoColors.activeBlue,
                  ),
                ),
              ),
            ],
          )
        : AlertDialog(
            title: title != '' ? Text(title!) : null,
            content: Text(message!),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            actions: <Widget>[
              TextButton(
                onPressed: leftClick,
                child: Text(left!),
              ),
              TextButton(
                onPressed: rightClick,
                style: TextButton.styleFrom(
                    foregroundColor: isRedPositive
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary),
                child: Text(right!),
              ),
            ],
          );
  }
}
