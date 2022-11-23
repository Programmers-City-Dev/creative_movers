import 'package:creative_movers/data/remote/model/account_type_response.dart';
import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactItem extends StatefulWidget {
  const ContactItem(
      {Key? key,
      required this.isAdded,
      required this.onTap,
      required this.connect})
      : super(key: key);
  final bool isAdded;
  final Connect connect;
  final void Function() onTap;

  @override
  _ContactItemState createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                   CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.lightGrey,
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(widget.connect.profilePhotoPath),
                    ),
// ,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    ' ${widget.connect.firstname} ${widget.connect.lastname}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              InkWell(
                onTap: widget.onTap,
                child: SizedBox(
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
          const Divider()
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
