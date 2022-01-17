import 'package:flutter/material.dart';
class ImageList extends StatefulWidget {
  const ImageList({Key? key}) : super(key: key);

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      alignment: Alignment.center,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 30,
                foregroundColor: Colors.red,
                backgroundImage: NetworkImage(
                  'https://i.pinimg.com/736x/d2/b9/67/d2b967b386e178ee3a148d3a7741b4c0.jpg',
                ),

              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Center(
                  child: Text(
                    'Victor',maxLines: 1,
                    style: TextStyle(fontSize: 13),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
