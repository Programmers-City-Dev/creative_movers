import 'package:flutter/material.dart';

class ProfileDialog extends StatefulWidget {
  final String? title;
  // final List<Widget> children;
  final Widget Function(BuildContext, void Function(void Function())) builder;
  final double minHeight;

  const ProfileDialog({
    Key? key,
    required this.title,
    required this.builder,
    this.minHeight = 0.0,
  }) : super(key: key);
  @override
  _ProfileDialogState createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      child: Container(
        constraints: BoxConstraints(
            minHeight: widget.minHeight, maxHeight: size.height * .8),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(10), boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ]),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title!,
                    style: TextStyle(
                        color: const Color(0xFF363636).withOpacity(.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Icon(
                      Icons.cancel_outlined,
                      color: Colors.black.withOpacity(.2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              StatefulBuilder(
                builder: widget.builder,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
