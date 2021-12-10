import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactItem extends StatefulWidget {
  const ContactItem({Key? key, required this.isAdded, required this.onTap}) : super(key: key);
  final bool isAdded;
  final   void Function() onTap;

  @override
  _ContactItemState createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.lightGrey,

// ,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Anyanwu Nzubechi',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              InkWell(
                onTap: widget.onTap ,
                child: Container(
                  height: 20,
                  width: 20,
                  child: Center(
                    child: widget.isAdded
                        ? SvgPicture.asset(AppIcons.svgAdded)
                        : SvgPicture.asset(AppIcons.svgAdd),
                  ),
                ),
              )
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}
//
// ListTile
// (
//
// contentPadding: EdgeInsets.symmetric(vertical: 6
// ,
// horizontal: 16
// )
// ,
// minLeadingWidth: 50
// ,
// leading: CircleAvatar
// (
// radius: 45
// ,
// backgroundColor: AppColors.lightGrey,
//
// // ,
// )
// ,
// title: const Text('
//
// Anyanwu Nzubechi
// '
// )
// ,
// trailing: Container
// (
// height: 20
// ,
// width: 20
// ,
// child: Center
// (
// child: SvgPicture.asset(AppIcons.svgAdded),
// )
// ,
// )
// ,
// );
