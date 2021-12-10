import 'package:creative_movers/screens/auth/widgets/more_details_form.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MoreDetailsScreen extends StatefulWidget {
  const MoreDetailsScreen({Key? key}) : super(key: key);

  @override
  _MoreDetailsScreenState createState() => _MoreDetailsScreenState();
}

class _MoreDetailsScreenState extends State<MoreDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      body: Container(
        color: AppColors.primaryColor,
        child: Stack(
          children: [
            Align(
                alignment: Alignment.bottomCenter,
                child: MoreDetailsForm(
                  mainContext: context,
                ))
          ],
        ),
      ),
    );
  }
}
