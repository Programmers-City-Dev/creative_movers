import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class WelcomeDialog extends StatelessWidget {
  final VoidCallback onNavigate;
  const WelcomeDialog({
    Key? key,
    required this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Expanded(child: Image.asset("assets/images/welcome.gif")),
            Container(
              margin: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Hey! Welcome",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black)),
                  const SizedBox(
                    height: 32,
                  ),
                  const Text(
                      "We are more than happy that you have joined the CreativeMovers, please take a litle time to complete your profile",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: AppColors.grey)),
                  const SizedBox(
                    height: 32,
                  ),
                  CustomButton(
                    onTap: onNavigate,
                    child: const Text(
                      'Complete Profile',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomButton(
                    color: Colors.white,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Remind me later',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
