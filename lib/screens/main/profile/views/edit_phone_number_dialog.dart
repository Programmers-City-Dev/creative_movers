import 'package:creative_movers/blocs/profile/profile_bloc.dart';
import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../../di/injector.dart';
import '../../../../helpers/app_utils.dart';
import '../../../../theme/app_colors.dart';
import '../../../widget/custom_button.dart';

class EditPhoneNumberDialog extends StatefulWidget {
  final Function(User) onSuccess;
  final String phoneNumber;
  const EditPhoneNumberDialog(
      {Key? key, required this.onSuccess, required this.phoneNumber})
      : super(key: key);

  @override
  _EditPhoneNumberDialogState createState() => _EditPhoneNumberDialogState();
}

class _EditPhoneNumberDialogState extends State<EditPhoneNumberDialog> {
  late final TextEditingController _phoneNumberController;
  final GlobalKey<FormState> _fieldKey = GlobalKey<FormState>();
  final _profileBloc = ProfileBloc(injector.get());

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController(text: widget.phoneNumber);
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
          Navigator.of(context).pop();
          // AppUtils.cancelAllShowingToasts();
          AppUtils.showCustomToast(
              "Phone number has been updated successfully");
          // _updateProfile(
          //     state.photo, state.isProfilePhoto);
        }
        if (state is ProfileUpdateErrorState) {
          Navigator.of(context).pop();
          AppUtils.showCustomToast(state.error);
        }
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
              'Edit phone number',
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
                child: TextFormField(
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Enter phone number'),
                    // EmailValidator(errorText: 'Enter a valid email'),
                  ]),
                  controller: _phoneNumberController,
                  cursorColor: AppColors.textColor,
                  keyboardType: TextInputType.phone,
                  // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      focusedBorder: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: AppColors.textColor,
                      ),
                      hintText: 'Enter your phone number',
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
                  _profileBloc.add(
                      UpdateProfileEvent(phone: _phoneNumberController.text));
                  // _authBloc.add(ForgotPasswordEvent(email: _phoneNumberController.text));

                }
              },
              child: const Text('Continue'),
            )
          ],
        ),
      ),
    );
  }
}
