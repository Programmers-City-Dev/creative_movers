// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// Author : Ketan Ramani
// Use : To Show Platform Specific Dialog (Android & iOS)

class BottomSheetMenuList extends StatelessWidget {
  final String? title;
  final bool isRedPositive;
  final List<BottomSheetMenu> items;
  final Function(int index) onSelect;

  const BottomSheetMenuList({
    Key? key,
    this.title = '',
    this.isRedPositive = false,
    required this.onSelect,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items
            .map((e) => ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    onSelect(items.indexOf(e));
                  },
                  leading: e.icon,
                  title: Text(
                    e.title,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class BottomSheetMenu extends Equatable {
  final String title;
  final Widget? icon;
  const BottomSheetMenu({
    required this.title,
    this.icon,
  });

  @override
  List<Object?> get props => [title, if (icon != null) icon];
}
