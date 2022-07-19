import 'package:creative_movers/models/ethnicity.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'custom_dropdown_menu_tile.dart';

class EthnicityDropdownMenuItem<T> extends StatelessWidget {
  final EthnicityModel value;
  final String? selected;
  final GlobalKey<CustomDropdownMenuExpansionTileState> tileKey;
  final Function onSelect;

  const EthnicityDropdownMenuItem({
    Key? key,
    required this.selected,
    required this.tileKey,
    required this.onSelect,
    required this.value,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Text(
            value.title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
        Column(
            children: value.values.map((e) {
          return GestureDetector(
            onTap: () {
              onSelect(e);
              tileKey.currentState?.collapse();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                  color: selected == e
                      ? AppColors.primaryColor.withOpacity(.15)
                      : Colors.transparent),
              child: Text(
                e,
                style: const TextStyle(
                  color: Color(0xFF3E3E3E),
                  fontSize: 13,
                ),
              ),
            ),
          );
        }).toList()),
      ],
    );

    // return GestureDetector(
    //   onTap: () {
    //     onSelect(value);
    //     tileKey.currentState?.collapse();
    //   },
    //   child: Container(
    //     width: double.infinity,
    //     padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    //     decoration: BoxDecoration(
    //         color: isSelected
    //             ? Color(0xFFAD3BFC).withOpacity(.15)
    //             : Colors.transparent),
    //     child: Text(
    //       text,
    //       style: TextStyle(
    //         color: Color(0xFF3E3E3E),
    //         fontSize: 13,
    //       ),
    //     ),
    //   ),
    // );
  }
}
