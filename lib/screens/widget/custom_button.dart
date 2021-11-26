import 'package:creative_movers/theme/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [

        AppColors.primaryColor
      ])),
      child: ElevatedButton(

          style: ElevatedButton.styleFrom(

            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            primary: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          onPressed: () {},
          child: Center(
            child: Row(
                        mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.logout_outlined,
                ),
                Text(' SignUp')],
            ),
          )),
    );
  }
}
