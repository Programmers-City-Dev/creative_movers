import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnboardingItem extends StatefulWidget {
  const OnboardingItem({Key? key, this.text, required this.img, this.header}) : super(key: key);
  final Text? text;
  final String? header;
  final String img;

  @override
  _OnboardingItemState createState() => _OnboardingItemState();
}

class _OnboardingItemState extends State<OnboardingItem> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryColor.withOpacity(0.2),
                AppColors.primaryColor.withOpacity(0.5),
                AppColors.primaryColor.withOpacity(0.8),

              ])),
        ),
        decoration:  BoxDecoration(
            image: DecorationImage(fit: BoxFit.cover, image: AssetImage(widget.img))
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
             Text(
             widget.header!,
              style: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            widget.text!

            // Text(' dcsdc oidco d',style: TextStyle(fontSize: 20,color: Colors.white),
            // )
          ],
        ),
      )
    ]);
  }
}
