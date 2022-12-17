import 'package:flutter/material.dart';

import 'custom_dropdown_menu_tile.dart';

class CustomDropdownMenu<T> extends StatefulWidget {
  final String? label;
  final String? headTitle;
  final String? icon;
  final T value;
  final Function onSelect;
  final VoidCallback? handleTap;

  // final List<CustomDropdownItem> items;
  final List items;
  final GlobalKey<CustomDropdownMenuExpansionTileState> tileKey;

  const CustomDropdownMenu({
    Key? key,
    required this.headTitle,
    required this.value,
    required this.onSelect,
    required this.items,
    required this.tileKey,
    this.icon,
    this.label,
    this.handleTap,
  }) : super(key: key);
  @override
  _CustomDropdownMenuState createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              widget.label!,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w400),
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFBDBDBD).withOpacity(.4)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: CustomDropdownMenuExpansionTile(
            key: widget.tileKey,
            handleTap: widget.handleTap,
            icon: widget.icon,
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            title: Text(
              widget.headTitle!,
              style: const TextStyle(
                color: Color(0xFF3E3E3E),
                fontSize: 14,
              ),
            ),
            expandedAlignment: Alignment.centerLeft,
            children: widget.items as List<Widget>,
          ),
        ),
      ],
    );
  }
}
