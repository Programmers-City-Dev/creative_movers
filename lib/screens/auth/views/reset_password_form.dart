import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm(
      {Key? key, required this.onFinish, required this.email})
      : super(key: key);
  final VoidCallback onFinish;
  final String email;

  @override
  _ResetPasswordFormState createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final AuthBloc _authBloc = AuthBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool isLoading = false;
  bool obscure = false;
  bool obscure2 = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        _listenToResetPasswordState(context, state);
      },
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
            color: AppColors.smokeWhite,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Form(
          key: _formKey,
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
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Set a new password for your account so you can login and acces all your features',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _newPasswordController,
                enabled: !isLoading,
                validator: (value) {
                  if (_newPasswordController.text.isEmpty) {
                    return 'Enter a new Password';
                  }
                  return null;
                },
                cursorColor: AppColors.textColor,
                obscureText: obscure,
                decoration: InputDecoration(
                    focusedBorder: const OutlineInputBorder(),
                    prefixIcon: const Icon(
                      Icons.password_outlined,
                      color: AppColors.textColor,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscure = !obscure;
                        });
                      },
                      icon: obscure
                          ? const Icon(
                              Icons.visibility_off_outlined,
                              color: AppColors.textColor,
                            )
                          : const Icon(
                              Icons.visibility_outlined,
                              color: AppColors.textColor,
                            ),
                    ),
                    hintText: 'New Password',
                    border: const OutlineInputBorder()),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                enabled: !isLoading,
                obscureText: obscure2,
                controller: _confirmPasswordController,
                cursorColor: AppColors.textColor,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscure2 = !obscure2;
                        });
                      },
                      icon: obscure2
                          ? const Icon(
                              Icons.visibility_off_outlined,
                              color: AppColors.textColor,
                            )
                          : const Icon(
                              Icons.visibility_outlined,
                              color: AppColors.textColor,
                            ),
                    ),
                    focusedBorder: const OutlineInputBorder(),
                    prefixIcon: const Icon(
                      Icons.password_outlined,
                      color: AppColors.textColor,
                    ),
                    hintText: 'Confirm Password',
                    border: const OutlineInputBorder()),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: CustomButton(
                  onTap: () {
                    _authBloc.add(ResetPasswordEvent(
                        password_confirmation: _confirmPasswordController.text,
                        password: _newPasswordController.text,
                        email: widget.email));
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
      ),
    );
  }

  void _listenToResetPasswordState(BuildContext context, AuthState state) {
    if (state is ResetPasswordLoadingState) {
      setState(() {
        isLoading = true;
      });
    } else if (state is ResetPasswordSuccessState) {
      widget.onFinish();
      setState(() {
        isLoading = false;
      });
    } else if (state is ResetPasswordFailureState) {
      AppUtils.showCustomToast(state.error);
      setState(() {
        isLoading = false;
      });
    }
  }
}
