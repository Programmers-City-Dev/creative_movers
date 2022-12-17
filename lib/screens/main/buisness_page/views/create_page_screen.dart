import 'package:creative_movers/screens/main/buisness_page/views/create_page_form.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 1.0, top: 18.0, bottom: 8),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const CircleAvatar(
                      backgroundColor: AppColors.lightGrey,
                      radius: 20,
                      child: Center(
                        child: Icon(
                          Icons.chevron_left_rounded,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  const Text(
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
            const Expanded(
              child: CreatePageForm(),
            ),
          ],
        ),
      )),
    );
  }
}
