import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/extension.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:creative_movers/main.dart';
import 'package:creative_movers/models/register_response.dart';
import 'package:creative_movers/screens/auth/views/login_screen.dart';
import 'package:creative_movers/screens/auth/views/more_details_screen.dart';
import 'package:creative_movers/screens/auth/widgets/form_field.dart';
import 'package:creative_movers/screens/main/home_screen.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool obscure = true;

  final AuthBloc _authBloc = AuthBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        _listenToSignupState(state, context);
      },
      child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                controller: _usernameController,
                // focusNode: _focusNode,
                inputAction: TextInputAction.next,
                validator: MultiValidator([
                  RequiredValidator(errorText: "Please enter a username"),
                  MinLengthValidator(3,
                      errorText: "Username must be at least 3 characters long"),
                  MaxLengthValidator(20,
                      errorText: "Username must be at most 20 characters long"),
                ]),
                icon: Icons.person,
                hint: context.localization.username,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextField(
                validator: MultiValidator([
                  RequiredValidator(errorText: "Please enter an email"),
                  EmailValidator(errorText: "Please enter a valid email")
                ]),
                controller: _emailController,
                // focusNode: _focusNode,
                inputAction: TextInputAction.next,
                icon: Icons.mail_rounded,
                hint: context.localization.email,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextField(
                controller: _passwordController,
                // focusNode: _focusNode,
                inputAction: TextInputAction.done,
                validator: MultiValidator([
                  RequiredValidator(errorText: "Please enter a password"),
                  MinLengthValidator(6,
                      errorText: "Password must be at least 6 characters long"),
                  MaxLengthValidator(20,
                      errorText: "Password must be at most 20 characters long"),
                ]),
                onFieldSubmitted: (p0) => _submitForm(),
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
                hint: context.localization.password,
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                  child: CustomButton(
                onTap: () {
                  _submitForm();
                  // Navigator.of(context).push(MaterialPageRoute(
                  //   builder: (context) => const MoreDetailsScreen(),
                  // ));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.logout_outlined,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(context.localization.signUp)
                  ],
                ),
              )),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: context.localization.alreadyHasAnAccountText,
                      style: const TextStyle(color: Colors.black)),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ));
                      },
                    text: context.localization.login,
                    style: const TextStyle(
                        color: AppColors.primaryColor,
                        decoration: TextDecoration.underline),
                  ),
                ])),
              ),
            ],
          )),
    );
  }

  void _listenToSignupState(AuthState state, BuildContext context) {
    if (state is RegistrationLoadingState) {
      _showLoadingDialog();
    }
    if (state is RegistrationFailureState) {
      Navigator.of(context).pop();
      _showErrorToast(state.error);
    }
    if (state is RegistrationSuccessState) {
      cacheToken(state.response);
      Navigator.of(context).pop();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MoreDetailsScreen(),
          ),
          (route) => false);
    }
  }

  void _showLoadingDialog() {
    AppUtils.showAnimatedProgressDialog(context);
  }

  void _showErrorToast(String message) {
    CustomSnackBar.showError(context, message: message);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _authBloc.add(RegisterEvent(
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text));
    }
  }

  void cacheToken(AuthResponse response) {
    StorageHelper.setString(
        StorageKeys.registrationStage, response.user.regStatus.toString());
    StorageHelper.setString(StorageKeys.token, response.user.apiToken);
    // StorageHelper.setBoolean(StorageKeys.stayLoggedIn, true);
  }

  void showDialog() {
    AppUtils.showShowConfirmDialog(context,
        message: ' Welcome',
        cancelButtonText: 'cancelButtonText',
        confirmButtonText: '',
        onConfirmed: () {},
        onCancel: () {});

  }
}
