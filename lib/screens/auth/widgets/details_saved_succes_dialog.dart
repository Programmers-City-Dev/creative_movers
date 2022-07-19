import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/main/home_screen.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailsSavedDialog extends StatefulWidget {
  final bool? isFirstTime;
  final String paymentMode;
  final String? paymentType;
  final String? paymentAmount;
  final String? duration;
  const DetailsSavedDialog(
      {Key? key,
      this.isFirstTime = false,
      required this.paymentMode,
      this.paymentType,
      this.paymentAmount,
      this.duration})
      : super(key: key);

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
              Text(
                widget.paymentType == "trial"
                    ? "\$0.00"
                    : '\$${widget.paymentAmount}.00',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    color: AppColors.chipsColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Text(
                  widget.paymentType == 'trial'
                      ? 'Free trial expires in 9 days'
                      : 'Payment Due Date: 12/28/2021',
                  style: const TextStyle(color: AppColors.smokeWhite),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.paymentMode == 'trial'
                    ? 'Your 9 day trial period have been activated and you have moved to the front now.'
                    : 'Your ${widget.duration} payment have been activated and you have moved to the front now.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textColor),
              ),
              const SizedBox(
                height: 16,
              ),
              // CustomButton(onTap: (){},child: Text("Finalize Your Profile"),),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(
                                showWelcomeDialog: widget.isFirstTime,
                              )),
                      (route) => false);
                },
                child: const Text("Start Exploring"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
