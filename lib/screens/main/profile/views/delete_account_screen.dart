import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/blocs/profile/profile_bloc.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/widget/adaptive_dialog.dart';
import 'package:creative_movers/screens/widget/cm_password_field.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final List<String> reasons = [
    "I don't like the app",
    "Something was broken",
    "I have a privacy concern",
    "Created a second account",
    "Not satisfied with the services",
    "Other"
  ];
  int selectedReasonIndex = -1;

  final _otherReasonTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _profileBloc = ProfileBloc(injector.get());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Delete Account", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(
          color: Colors.black45,
        ),
        backgroundColor: AppColors.smokeWhite,
        elevation: 0,
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        bloc: _profileBloc,
        listener: (context, state) {
          if (state is ProfileLoading) {
            AppUtils.showAnimatedProgressDialog(context,
                title: "Processing, please wait");
          }
          if (state is AccountDeleted) {
            Navigator.pop(context);
            AppUtils.showCustomToast("Account deleted successfully");
            injector.get<AuthBloc>().add(LogoutEvent());
          }

          if (state is ProfileErrorState) {
            Navigator.pop(context);
            AppUtils.showErrorDialog(context,
                message: state.error,
                title: "Error",
                confirmButtonText: "OK", onConfirmed: () {
              Navigator.pop(context);
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32 * 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "It's sad to see you make this decision!",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    "It's quiet unfortunate to see you go, please before you continue"
                    " we would like you to tell us why you would want to delete your"
                    " account so we can improve our application.",
                    style: TextStyle(color: AppColors.textColor, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ...reasons.map(
                    (e) {
                      if (reasons.indexOf(e) == reasons.length - 1) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RadioListTile<int>(
                              value: reasons.indexOf(e),
                              groupValue: selectedReasonIndex,
                              onChanged: (value) {
                                setState(() {
                                  selectedReasonIndex = value!;
                                });
                              },
                              title: Text(
                                e,
                                style: const TextStyle(
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Visibility(
                                visible:
                                    selectedReasonIndex == reasons.length - 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: TextFormField(
                                    validator: (val) {
                                      if (selectedReasonIndex ==
                                              reasons.length - 1 &&
                                          val!.isEmpty) {
                                        return "Please enter your reason";
                                      }
                                      return null;
                                    },
                                    controller: _otherReasonTextController,
                                    minLines: 4,
                                    maxLines: 4,
                                    cursorColor: AppColors.textColor,
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        hintText: 'Enter your reason',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16))),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }
                      return RadioListTile<int>(
                        value: reasons.indexOf(e),
                        groupValue: selectedReasonIndex,
                        onChanged: (value) {
                          setState(() {
                            selectedReasonIndex = value!;
                          });
                        },
                        title: Text(e,
                            style: const TextStyle(
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w500)),
                      );
                    },
                  ).toList(),
                  const SizedBox(
                    height: 32,
                  ),
                  CustomButton(
                    onTap: () {
                      if (selectedReasonIndex == reasons.length - 1) {
                        if (_formKey.currentState!.validate()) {
                          _showComnfirmDialog();
                        }
                      } else {
                        _showComnfirmDialog();
                      }
                    },
                    isEnabled: selectedReasonIndex >= 0,
                    child: const Text("Continue"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showComnfirmDialog() async {
    final passwordController = TextEditingController();
    var passwordFormKey = GlobalKey<FormState>();

    showDialog<bool>(
      context: context,
      builder: (context) {
        return AdaptiveDialog(
          "Note that this action "
              "will permanently delete your account"
              " from our system and you won't be able"
              " to recover it.\n\n"
              "Are you sure you want to do this?",
          "Cancel",
          "Continue",
          leftClick: () {
            Navigator.of(context).pop();
          },
          rightClick: () {
            // Show confirm password dialog before deletion
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: ((context) => Dialog(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Confirm Password",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            Form(
                              key: passwordFormKey,
                              child: CmPasswordField(
                                controller: passwordController,
                                inputAction: TextInputAction.done,
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "Please enter a password"),
                                  MinLengthValidator(6,
                                      errorText:
                                          "Password must be at least 6 characters long"),
                                  MaxLengthValidator(20,
                                      errorText:
                                          "Password must be at most 20 characters long"),
                                ]),
                                icon: Icons.lock,
                                hint: "Enter your password",
                              ),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            CustomButton(
                              onTap: () {
                                if (passwordFormKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                  _profileBloc.add(DeleteAccount(
                                      reason: selectedReasonIndex ==
                                              reasons.length - 1
                                          ? _otherReasonTextController.text
                                          : reasons[selectedReasonIndex],
                                      password: passwordController.text));
                                }
                              },
                              color: Colors.red,
                              isEnabled: selectedReasonIndex != 0,
                              child: const Text("Delete",
                                  style: TextStyle(color: Colors.white)),
                            )
                          ],
                        ),
                      ),
                    )));
          },
          isRedPositive: true,
          title: "Delete Account",
        );
      },
    );
  }
}
