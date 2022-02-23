import 'package:creative_movers/data/remote/model/get_connects_response.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_stack/image_stack.dart';

class RequestItem extends StatefulWidget {
  const RequestItem({Key? key, required this.connection}) : super(key: key);
  final Connection connection;

  @override
  _RequestItemState createState() => _RequestItemState();
}

class _RequestItemState extends State<RequestItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 30,
              foregroundColor: Colors.red,
              backgroundImage: NetworkImage(widget.connection.profilePhotoPath),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.connection.firstname + ' ' + widget.connection.lastname,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              Text(
                widget.connection.username,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Accept',
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: AppColors.lightGreen),
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Decline',
                            style:
                                TextStyle(color: AppColors.red, fontSize: 12),
                          ),
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: AppColors.lightred),
                        )),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
