import 'package:creative_movers/screens/main/feed/widgets/comment_item.dart';
import 'package:creative_movers/screens/main/feed/widgets/post_text_item.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({Key? key}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(color: AppColors.textColor, fontSize: 18),
        iconTheme: const IconThemeData(color: AppColors.textColor),
        backgroundColor: Colors.white,
        title: Text('Comments'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const FaIcon(FontAwesomeIcons.paperPlane),
              onPressed: () {},
            ),
          )
        ],
      ),
      body: Column(

        children: [
        
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

              PostTextItem(),
              Divider(color: Colors.grey,),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:6 ,
                itemBuilder: (context, index) => CommentItem(),),
            ],),
          ),
        ),
       
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),

        child: Column(
          children: [
            Divider(),
            Row(children: const[
              CircleAvatar(
                backgroundColor: AppColors.lightBlue,
                radius: 20,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://www.w3schools.com/w3images/avatar6.png'),
                  radius: 18,
                ),
              ),
              SizedBox(width: 15,),
              Expanded(child: TextField(decoration: InputDecoration(border: InputBorder.none,hintText: 'Add a comment'),)),
              Text('Post',style: TextStyle(color: AppColors.primaryColor,),)
            ],),
          ],
        ),
        )

      ],),
    );
  }
}
