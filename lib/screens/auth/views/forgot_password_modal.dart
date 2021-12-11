import 'package:creative_movers/screens/auth/widgets/form_field.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPasswordModal extends StatefulWidget {
  const ForgotPasswordModal({Key? key}) : super(key: key);

  @override
  _ForgotPasswordModalState createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal> {
  String screen = 'forgot password';

  @override
  Widget build(BuildContext context) {
    return screen == 'forgot password'
        ? Container(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                  color: AppColors.smokeWhite,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: Container(
                    color: Colors.grey,
                    width: 200,
                    height: 2.5,
                  )),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Forgot Password',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Enter your email for verification process we will send you a 4 digit code to your email ',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: TextFormField(
                      cursorColor: AppColors.textColor,
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.mail,
                            color: AppColors.textColor,
                          ),
                          hintText: 'Enter Your Email',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomButton(
                    onTap: () {
                      setState(() {
                        screen = 'digit code';
                      });
                    },
                    child: Text('Continue'),
                  )
                ],
              ),
            ),
          )
        : screen == 'digit code'
            ? Container(
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                    color: AppColors.smokeWhite,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: Container(
                      color: Colors.grey,
                      width: 200,
                      height: 2.5,
                    )),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Enter 4 Digits Code',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Enter the 4 digits code you received on your mail',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 13),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Form(
                        child: Form(
                            child: PinCodeTextField(
                              blinkWhenObscuring: true,
                                appContext: context,
                                length: 4,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderWidth: 1,
                                  inactiveColor: AppColors.textColor,
                                  activeColor: AppColors.primaryColor,
                                  errorBorderColor: Colors.red,
                                  selectedColor: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                  fieldHeight: 50,
                                  fieldWidth: 50,
                                  activeFillColor: Colors.white,
                                ),
                                onChanged: (val){}))),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: CustomButton(
                        onTap: () {
                          setState(() {
                            screen = '';
                          });
                        },
                        child: Text('Continue'),
                      ),
                    )
                  ],
                ),
              )
            : Container(
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                    color: AppColors.smokeWhite,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: Container(
                      color: Colors.grey,
                      width: 200,
                      height: 2.5,
                    )),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Reset Password',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Set a new password for your account so you can login and acces all your features',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 13),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      cursorColor: AppColors.textColor,
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.mail,
                            color: AppColors.textColor,
                          ),
                          hintText: 'New Password',
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      cursorColor: AppColors.textColor,
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.mail,
                            color: AppColors.textColor,
                          ),
                          hintText: 'Confirm Password',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: CustomButton(
                        onTap: () {},
                        child: Text('Continue'),
                      ),
                    )
                  ],
                ),
              );
  }
}
