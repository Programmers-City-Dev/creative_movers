import 'dart:developer';
import 'dart:ui';

import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/data/local/model/cached_user.dart';
import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:creative_movers/screens/auth/views/account_type_screen.dart';
import 'package:creative_movers/screens/auth/views/forgot_password_modal.dart';
import 'package:creative_movers/screens/auth/views/more_details_screen.dart';
import 'package:creative_movers/screens/main/payment/views/payment_screen.dart';
import 'package:creative_movers/screens/auth/views/signup_screen.dart';
import 'package:creative_movers/screens/main/home_screen.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'form_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool obscure = true;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthBloc _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        _listenToAuthState(context, state);
      },
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              validator: MultiValidator([
                RequiredValidator(errorText: 'Email is required'),
                EmailValidator(errorText: 'Enter a valid email'),
              ]),
              inputAction: TextInputAction.next,
              controller: _emailController,
              icon: Icons.mail_rounded,
              hint: 'Email Address',
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextField(
              controller: _passwordController,
              validator: MultiValidator([
                RequiredValidator(errorText: 'Password is required'),
                MinLengthValidator(6,
                    errorText: 'Password must be at least 6 characters'),
              ]),
              inputAction: TextInputAction.done,
              onFieldSubmitted: (p0) => _submitLoginForm(),
              toggle_icon: IconButton(
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
              obscure: obscure,
              icon: Icons.lock,
              hint: 'Password',
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              onTap: () {
                _submitLoginForm();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.logout_outlined,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('Login')
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      isScrollControlled: true,
                      context: context,
                      builder: (c) => BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
                            child: ForgotPasswordModal(
                              onComplete: () {
                                log('complete');
                                Navigator.pop(context);
                                AppUtils.showSuccessSuccessDialog(context,
                                    message:
                                        'You successfully changed your password proceed to login ');
                              },
                            ),
                          ));
                },
                child: const Text(
                  'Forgot Password',
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: RichText(
                  text: TextSpan(children: [
                const TextSpan(
                    text: 'I dont have an account  ?  ',
                    style: TextStyle(color: AppColors.black)),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ));
                    },
                  text: 'SignUp',
                  style: const TextStyle(
                      color: AppColors.primaryColor,
                      decoration: TextDecoration.underline),
                ),
              ])),
            )
          ],
        ),
      ),
    );
  }

  void _listenToAuthState(BuildContext context, AuthState state) {
    if (state is LoginLoadingState) {
      AppUtils.showAnimatedProgressDialog(context);
    }
    if (state is LoginFailureState) {
      Navigator.of(context).pop();
      CustomSnackBar.showError(context, message: state.error);
    }
    if (state is LoginSuccessState) {
      cacheToken(state.response);
      Navigator.of(context).pop();
      if (state.response.user.regStatus != 'account_type') {
        AppUtils.showMessageDialog(
          context,
          message:
              "Welcome ${state.response.user.username}, We noticed you haven't completed your registration, Press CONTINUE to finish up ",
          onClose: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) =>
                      currentPage(context, state.response.user.regStatus),
                ),
                (route) => false);
          },
        );
      } else {
        StorageHelper.setBoolean(StorageKeys.stayLoggedIn, true);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false);
      }
    }
  }

  void _submitLoginForm() {
    if (_formKey.currentState!.validate()) {
      _authBloc.add(LoginEvent(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ));
    }
  }

  void cacheToken(AuthResponse response) async {
    injector
        .get<CacheCubit>()
        .updateCachedUserData(CachedUser.fromMap(response.user.toMap()));
    StorageHelper.setString(StorageKeys.email, response.user.email.toString());
    StorageHelper.setString(
        StorageKeys.username, response.user.username.toString());
    StorageHelper.setString(
        StorageKeys.token, response.user.apiToken.toString());
    StorageHelper.setString(
        StorageKeys.firstname, response.user.firstname.toString());
    StorageHelper.setString(StorageKeys.user_id, response.user.id.toString());

    // StorageHelper.setBoolean(StorageKeys.stayLoggedIn, true);
  }

  Widget currentPage(BuildContext context, String? stage) {
    // --------------Status Check--------------
    if (stage == 'new') {
      return const MoreDetailsScreen();
    } else if (stage == 'biodata') {
      return const AccountTypeScreen(
        categories: [],
      );
    } else if (stage == 'account_type') {
      return const PaymentScreen();
    } else if (stage == 'payment') {
      return const HomeScreen();
    } else {
      return const HomeScreen();
    }
  }
}
