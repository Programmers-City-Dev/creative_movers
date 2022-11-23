import 'dart:async';

import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ConfirmTokenForm extends StatefulWidget {
  const ConfirmTokenForm(
      {Key? key, required this.onFinish, required this.email})
      : super(key: key);
  final VoidCallback onFinish;
  final String email;

  @override
  _ConfirmTokenFormState createState() => _ConfirmTokenFormState();
}

class _ConfirmTokenFormState extends State<ConfirmTokenForm> {
  final AuthBloc _authBloc = AuthBloc();
  bool isLoading = false;
  int _counter = 30;

  final _pinController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        _listenToConfirmPasswordEvent(context, state);
      },
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
            color: AppColors.smokeWhite,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
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
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Enter the 4 digits code you received on your mail',
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
            ),
            const SizedBox(
              height: 15,
            ),
            Form(
                child: Form(
                    key: _formKey,
                    child: PinCodeTextField(
                        keyboardType: TextInputType.number,
                        errorTextSpace: 20,
                        enabled: !isLoading,
                        blinkWhenObscuring: true,
                        appContext: context,
                        length: 4,
                        controller: _pinController,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText:
                                  'Please enter the code sent to your email'),
                          MinLengthValidator(4,
                              errorText: 'Should be a 4 digit code'),
                        ]),
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
                          activeFillColor: AppColors.white,
                        ),
                        onChanged: (val) {}))),
            const SizedBox(
              height: 5,
            ),
            Center(
                child: BlocConsumer<AuthBloc, AuthState>(
              bloc: _authBloc,
              listener: (context, state) {
                _listenToForgotPasswordState(context, state);
              },
              builder: (context, state) {
                if (state is ForgotPasswordLoadingState) {
                  return const Text('Resending PIN....');
                }
                if (state is ForgotPasswordSuccessState) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      _counter > 0
                          ? Text('Resend code in $_counter secs')
                          : InkWell(
                              child: const Text(
                                'RESEND CODE',
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                              onTap: () {
                                _authBloc
                                    .add(ForgotPasswordEvent(email: 'cdc'));
                              },
                            ),
                    ],
                  );
                }
                if (state is ForgotPasswordFailureState) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      _counter != 0
                          ? Text('Resend code in $_counter ')
                          : InkWell(
                              child: const Text(
                                'RESEND CODE',
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                              onTap: () {
                                _authBloc.add(
                                    ForgotPasswordEvent(email: widget.email));
                              },
                            ),
                    ],
                  );
                } else {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      _counter != 0
                          ? Text('Resend code in $_counter ')
                          : InkWell(
                              child: const Text(
                                'RESEND CODE',
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                              onTap: () {
                                _authBloc.add(
                                    ForgotPasswordEvent(email: widget.email));
                              },
                            ),
                    ],
                  );
                }
              },
            )),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: CustomButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _authBloc
                        .add(ConfirmTokenEvent(token: _pinController.text));
                  }
                },
                child: isLoading
                    ? const SizedBox(
                        height: 30,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Continue'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _listenToConfirmPasswordEvent(BuildContext context, AuthState state) {
    if (state is ConfirmTokenLoadingState) {
      setState(() {
        isLoading = true;
      });
    } else if (state is ConfirmTokenSuccessState) {
      widget.onFinish();
      setState(() {
        isLoading = false;
      });
    } else if (state is ConfirmTokenFailureState) {
      AppUtils.showCustomToast(state.error);
      setState(() {
        isLoading = false;
      });
    }
  }

  void _listenToForgotPasswordState(BuildContext context, AuthState state) {
    if (state is ForgotPasswordLoadingState) {
    } else if (state is ForgotPasswordSuccessState) {
      _counter = 30;
      AppUtils.showCustomToast('PIN SENT..');
      restarTimer();
    } else if (state is ForgotPasswordFailureState) {
      AppUtils.showCustomToast(state.error);
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 100 * 30), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void restarTimer() {
    if (timer != null) {
      timer!.cancel();
      startTimer();
    }
  }
}
