import 'package:creative_movers/screens/main/buisness_page/views/create_page_form.dart';
import 'package:creative_movers/screens/widget/add_image_wigdet.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreatePageScreen extends StatefulWidget {
  const CreatePageScreen({Key? key}) : super(key: key);

  @override
  _CreatePageScreenState createState() => _CreatePageScreenState();
}

class _CreatePageScreenState extends State<CreatePageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.smokeWhite,
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 18.0,left:1.0,top: 18.0,bottom: 8 ),
              child: Row(
                children: const [
                  CircleAvatar(
                    backgroundColor: AppColors.lightGrey,
                    radius: 20,
                    child: Center(
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  Text(
                    'Create Page',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    AddImageWidget(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Add Image to this page ',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Use Images that represent what he page is all about '
                      'like logo , This will appear in the search result',
                      style: TextStyle(fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CreatePageForm()
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
