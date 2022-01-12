import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class StatusViews extends StatefulWidget {
  const StatusViews({Key? key}) : super(key: key);

  @override
  _StatusViewsState createState() => _StatusViewsState();
}

class _StatusViewsState extends State<StatusViews> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      decoration:  const BoxDecoration(
        border: Border(bottom: BorderSide( width:10,color: Colors.red,style: BorderStyle.none)) ,
          color: Colors.white,
         ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(),
            height: 90,
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children:  [
                CircleAvatar(
                  radius: 25,
                  foregroundColor: Colors.red,
                  backgroundImage: const NetworkImage(
                    'https://i.pinimg.com/736x/d2/b9/67/d2b967b386e178ee3a148d3a7741b4c0.jpg',
                  ),
                  child:CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.lightGrey.withOpacity(0.5),
                    child:  Center(
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.add,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 90,
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
                        radius: 25,
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
                        'Victor',
                        style: TextStyle(fontSize: 10),
                      )),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
