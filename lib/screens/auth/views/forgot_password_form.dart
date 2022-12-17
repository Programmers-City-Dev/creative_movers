import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key, required this.onFinish})
      : super(key: key);
  final Function(String email) onFinish;

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _emailController = TextEditingController();
  final GlobalKey<FormState> _fieldKey = GlobalKey<FormState>();
  bool isLoading = false;
  final AuthBloc _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        _listenToForgotPasswordEventState(context, state);
      },
      child: Container(
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
                'Forgot Password',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Enter your email for verification process we will send you a 4 digit code to your email ',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _fieldKey,
                  child: TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Email is required'),
                      EmailValidator(errorText: 'Enter a valid email'),
                    ]),
                    enabled: !isLoading,
                    controller: _emailController,
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
              ),
              const SizedBox(
                height: 15,
              ),
              CustomButton(
                onTap: () {
                  if (_fieldKey.currentState!.validate()) {
                    _authBloc
                        .add(ForgotPasswordEvent(email: _emailController.text));
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
              )
            ],
          ),
        ),
      ),
    );
  }

  void _listenToForgotPasswordEventState(
      BuildContext context, AuthState state) {
    if (state is ForgotPasswordLoadingState) {
      setState(() {
        isLoading = true;
      });
    }
    if (state is ForgotPasswordSuccessState) {
      widget.onFinish(_emailController.text);
      setState(() {
        isLoading = false;
      });
    }
    if (state is ForgotPasswordFailureState) {
      setState(() {
        isLoading = false;
      });

      AppUtils.showCustomToast(state.error);
    }
  }

  void complete() {}
}
