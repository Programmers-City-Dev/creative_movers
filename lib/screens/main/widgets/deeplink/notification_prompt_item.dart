import 'package:creative_movers/models/deep_link_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationPromptItem extends StatefulWidget {
  final DeepLinkData? notification;
  final VoidCallback? onTap;
  final VoidCallback? onDone;

  const NotificationPromptItem(
      {Key? key, this.notification, this.onTap, this.onDone})
      : super(key: key);

  @override
  State<NotificationPromptItem> createState() => _NotificationPromptItemState();
}

class _NotificationPromptItemState extends State<NotificationPromptItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _position;
  bool isDoneShowing = false;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _position = Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0)).animate(
        CurvedAnimation(
            parent: _animationController, curve: Curves.decelerate));
    _animationController.forward();
    Future.delayed(const Duration(seconds: 15), () {
      _onDone();
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDone() {
    _animationController.reverse().then((value) {
      widget.onDone!();
      setState(() {
        isDoneShowing = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isDoneShowing
        ? const SizedBox.shrink()
        : SlideTransition(
            position: _position as Animation<Offset>,
            child: InkWell(
              onTap: () {
                widget.onTap!();
                _onDone();
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue, width: 1)),
                padding: const EdgeInsets.fromLTRB(16, 10, 13, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _leadingIcon(),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.notification!.title!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ),
                              const SizedBox(width: 15,),
                              InkWell(
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black.withOpacity(.2),
                                ),
                                onTap: () {
                                  _onDone();
                                },
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.notification!.message!,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black45),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _leadingIcon() {
    if (widget.notification!.type == null ||
        getIconFromType(widget.notification!.type).isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(4)),
      child: SvgPicture.asset(getIconFromType(widget.notification!.type)),
    );
  }

  String getIconFromType(String? type) {
    return '';
    // switch (type) {
    //   case 'appointment':
    //   case 'follow_up':
    //     return ImageUtil.ic_not_consult;
    //   case 'case':
    //     return ImageUtil.ic_not_case;
    //   case 'order':
    //   case 'pharmacy':
    //     return ImageUtil.ic_not_pharm;
    //   case 'diagnostic':
    //     return ImageUtil.ic_not_test;
    //   case 'chat':
    //     return ImageUtil.ic_not_message;
    //   case 'wallet':
    //     return ImageUtil.ic_not_wallet;
    //   case 'note':
    //     return ImageUtil.ic_not_note;
    //   case 'prescription':
    //     return ImageUtil.ic_not_presc;
    //   case 'community':
    //     return ImageUtil.ic_not_community;
    //   default:
    //     return '';
    // }
  }
}
