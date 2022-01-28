import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
class FollowersItem extends StatefulWidget {
  const FollowersItem({Key? key}) : super(key: key);

  @override
  _FollowersItemState createState() => _FollowersItemState();
}

class _FollowersItemState extends State<FollowersItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Row(

        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 30,
              foregroundColor: Colors.red,
              backgroundImage: NetworkImage(
                'https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg',
              ),

            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  const [
                          Text('Frank Trabivas',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),),
                          Text(
                            'Mover', style: TextStyle(fontSize: 13, color: Colors.grey),),


                        ],),
                    ),
                    Row(
                      children: [
                        TextButton(onPressed: () {}, child: const Text('Follow'), style: TextButton.styleFrom(backgroundColor: AppColors.lightBlue),),
                        const SizedBox(width: 7,),
                        const Icon(Icons.person_add_rounded,color: AppColors.primaryColor,),
                      ],
                    ),
                  ],
                ),

              ],
            ),
          ),



        ],),
    );
  }
}
