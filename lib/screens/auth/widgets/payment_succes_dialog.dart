import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentSuccesDialog extends StatefulWidget {
  const PaymentSuccesDialog({Key? key}) : super(key: key);

  @override
  _PaymentSuccesDialogState createState() => _PaymentSuccesDialogState();
}

class _PaymentSuccesDialogState extends State<PaymentSuccesDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // const Text(
            //   'Started 9 days trial !!',
            //   style: TextStyle(
            //       color: Colors.green,
            //       fontSize: 20,
            //       fontWeight: FontWeight.w500),
            // ),
            const SizedBox(
              height: 20,
            ),
            SvgPicture.asset(AppIcons.svgGood),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Paid Amount',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              '\$700,0',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  color: AppColors.chipsColor,
                  borderRadius: BorderRadius.circular(15)),
              child: const Text(
                'Next Payement Due Date: 12/28/2021',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.smokeWhite),
              ),
            ),
            SizedBox(height: 10,),
            const Text(
              'We have received your payment for one month subscription fee and you have moved to the front',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textColor),
            ),
            const SizedBox(height: 16,),
            Row(
              children: [
                Expanded(

                    child: OutlinedButton(

                      style: OutlinedButton.styleFrom(
                        primary: AppColors.primaryColor,
                          side:const BorderSide(color: AppColors.primaryColor) ,
                          padding: const EdgeInsets.all(16)),
                      onPressed: (){}, child:const Text("Finalize Your Profile",style: TextStyle(color: AppColors.primaryColor),),)),
              ],
            ),
            // CustomButton(onTap: (){},child: Text("Finalize Your Profile"),),
             const SizedBox(height: 10,),
             CustomButton(onTap: (){},child: const Text("Start Exploring"),)
          ],
        ),
      ),
    );
  }
}
