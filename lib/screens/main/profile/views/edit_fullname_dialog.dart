import 'dart:developer';

import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../../blocs/profile/profile_bloc.dart';
import '../../../../di/injector.dart';
import '../../../../helpers/app_utils.dart';
import '../../../../theme/app_colors.dart';
import '../../../widget/custom_button.dart';

class EditFullnameDialog extends StatefulWidget {
  final Function(User) onSuccess;
  final String firstName;
  final String lastName;

  const EditFullnameDialog({
    Key? key,
    required this.onSuccess,
    required this.firstName,
    required this.lastName,
  }) : super(key: key);

  @override
  _EditFullnameDialogState createState() => _EditFullnameDialogState();
}

class _EditFullnameDialogState extends State<EditFullnameDialog> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  final GlobalKey<FormState> _fieldKey = GlobalKey<FormState>();
  final _profileBloc = ProfileBloc(injector.get());

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      bloc: _profileBloc,
      listener: (context, state) {
        if (state is ProfileUpdateLoading) {
          AppUtils.showAnimatedProgressDialog(context,
              title: "Updating, please wait...");
        }
        if (state is ProfileUpdateLoadedState) {
          widget.onSuccess(state.updateProfileResponse.user);
          log("USER UPDATE: ${state.updateProfileResponse.user.toMap()}");
          Navigator.of(context).pop();
          // AppUtils.cancelAllShowingToasts();
          AppUtils.showCustomToast("Name has been updated successfully");
          StorageHelper.setString(
              StorageKeys.firstname, _firstNameController.text);
          // _updateProfile(
          //     state.photo, state.isProfilePhoto);
        }
        if (state is ProfileUpdateErrorState) {
          Navigator.of(context).pop();
          AppUtils.showCustomToast(state.error);
        }
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
              Center(
                  child: Container(
                color: Colors.grey,
                width: 100,
                height: 2.5,
              )),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Edit Names',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _fieldKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Enter your first name'),
                          // EmailValidator(errorText: 'Enter a valid email'),
                        ]),
                        controller: _firstNameController,
                        cursorColor: AppColors.textColor,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            focusedBorder: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.person,
                              color: AppColors.textColor,
                            ),
                            hintText: 'Update FirstName',
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Enter your last name'),
                          // EmailValidator(errorText: 'Enter a valid email'),
                        ]),
                        controller: _lastNameController,
                        cursorColor: AppColors.textColor,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            focusedBorder: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.person,
                              color: AppColors.textColor,
                            ),
                            hintText: 'Update Last Name',
                            border: OutlineInputBorder()),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              CustomButton(
                onTap: () {
                  if (_fieldKey.currentState!.validate()) {
                    _profileBloc.add(UpdateProfileEvent(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text));
                    // _authBloc.add(ForgotPasswordEvent(email: _phoneNumberController.text));

                  }
                },
                child: const Text('Continue'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
