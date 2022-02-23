import 'package:creative_movers/data/remote/model/get_connects_response.dart';
import 'package:flutter/material.dart';
import 'package:image_stack/image_stack.dart';

class ContactItem extends StatefulWidget {
  const ContactItem({Key? key, required this.connection}) : super(key: key);
  final Connection connection;

  @override
  _ContactItemState createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 30,
              foregroundColor: Colors.red,
              backgroundImage: NetworkImage(widget.connection.profilePhotoPath),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.connection.firstname +
                      ' ' +
                      widget.connection.lastname,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                Text(
                  widget.connection.username,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                widget.connection.connects.isNotEmpty
                    ? Row(
                        children: [
                          ImageStack(
                            imageList: widget.connection.connects
                                .map((e) => e.profilePhotoPath)
                                .toList(),
                            totalCount: widget.connection.connects.length,
                            // If larger than images.length, will show extra empty circle
                            imageRadius: 20,
                            // Radius of each images
                            imageCount: 2,
                            // Maximum number of images to be shown in stack
                            imageBorderWidth:
                                3, // Border width around the images
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.connection.connects.isNotEmpty
                                ? widget.connection.connects[0].firstname
                                : '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('+${widget.connection.connects.length}'),
                        ],
                      )
                    : SizedBox()
              ],
            ),
          ),
          const Icon(Icons.more_horiz),
        ],
      ),
    );
  }
}
