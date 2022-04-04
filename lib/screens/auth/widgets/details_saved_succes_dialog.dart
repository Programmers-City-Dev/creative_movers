import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/main/home_screen.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailsSavedDialog extends StatefulWidget {
  const DetailsSavedDialog({Key? key}) : super(key: key);

  @override
  _DetailsSavedDialogState createState() => _DetailsSavedDialogState();
}

class _DetailsSavedDialogState extends State<DetailsSavedDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(25),
        color: AppColors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // const Text(
              //   'Payment Succesful!!',
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
                ' Amount due',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                '\$7.0',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    color: AppColors.chipsColor,
                    borderRadius: BorderRadius.circular(15)),
                child: const Text(
                  'Payment Due Date: 12/28/2021',
                  style: TextStyle(color: AppColors.smokeWhite),
                ),
              ),
              SizedBox(height: 10,),
              const Text(
                'Your one month trial period have been activated and you have moved to the front now.',
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
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(),));
                        }, child:const Text("Finalize Your Profile",style: TextStyle(color: AppColors.primaryColor),),)),
                ],
              ),
              // CustomButton(onTap: (){},child: Text("Finalize Your Profile"),),
               const SizedBox(height: 10,),
               CustomButton(onTap: (){
                 
                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(),));
               },child: const Text("Start Exploring"),)
            ],
          ),
        ),
      ),
    );
  }
}
