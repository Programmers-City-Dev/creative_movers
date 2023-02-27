import 'package:creative_movers/screens/widget/adaptive_dialog.dart';
import 'package:creative_movers/screens/widget/cm_password_field.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
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
  int selectedReason = 0;

  final _otherReasonTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
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
                      " account so we can improve our application",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ...reasons.map(
                      (e) {
                        if (reasons.indexOf(e) + 1 == reasons.length) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RadioListTile<int>(
                                value: reasons.indexOf(e),
                                groupValue: selectedReason,
                                onChanged: (value) {
                                  setState(() {
                                    selectedReason = value!;
                                  });
                                },
                                title: Text(e),
                              ),
                              Form(
                                key: _formKey,
                                child: Visibility(
                                  visible: selectedReason + 1 == reasons.length,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: TextFormField(
                                      validator: (val) {
                                        if (selectedReason + 1 ==
                                                reasons.length &&
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
                          groupValue: selectedReason,
                          onChanged: (value) {
                            setState(() {
                              selectedReason = value!;
                            });
                          },
                          title: Text(e),
                        );
                      },
                    ).toList(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: CustomButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _showComnfirmDialog();
                    }
                  },
                  isEnabled: selectedReason != 0,
                  child: const Text("Continue"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComnfirmDialog() {
    final passwordController = TextEditingController();
    var passwordFormKey = GlobalKey<FormState>();

    showDialog<bool>(
      context: context,
      builder: (context) {
        return AdaptiveDialog(
          "Note that this action "
              "will permanently delete your account"
              " from our system and you won't be able"
              " to recover it.",
          "Cancel",
          "Continue",
          () {
            Navigator.of(context).pop(false);
          },
          () {
            // Show confirm password dialog before deletion
            Navigator.of(context).pop(true);
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
                                if (passwordFormKey.currentState!.validate()) {}
                              },
                              color: Colors.red,
                              isEnabled: selectedReason != 0,
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
