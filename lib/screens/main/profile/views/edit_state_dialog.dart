import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:creative_movers/data/remote/model/update_profile_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../../blocs/profile/profile_bloc.dart';
import '../../../../di/injector.dart';
import '../../../../helpers/app_utils.dart';
import '../../../../theme/app_colors.dart';
import '../../../widget/custom_button.dart';
class EditStateDialog extends StatefulWidget {
  final Function(User) onSuccess;
  const EditStateDialog({Key? key, required this.onSuccess}) : super(key: key);

  @override
  _EditStateDialogState createState() => _EditStateDialogState();
}

final _stateController = TextEditingController();
final GlobalKey<FormState> _fieldKey = GlobalKey<FormState>();
final _profileBloc = ProfileBloc(injector.get());
class _EditStateDialogState extends State<EditStateDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      bloc: _profileBloc,
      listener: (context, state) {
        if (state is ProfileUpdateLoading) {
          AppUtils.showAnimatedProgressDialog(
              context,
              title: "Updating, please wait...");
        }
        if (state is ProfileUpdateLoadedState) {
          widget.onSuccess(state.updateProfileResponse.user);
          Navigator.of(context).pop();
          // AppUtils.cancelAllShowingToasts();
          AppUtils.showCustomToast(
              "State has been updated successfully");
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
                'Edit State',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),

              Padding(
                padding: EdgeInsets.only(

                    bottom: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom),
                child: Form(
                  key: _fieldKey,
                  child: TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Enter your state'),
                      // EmailValidator(errorText: 'Enter a valid email'),
                    ]),

                    controller: _stateController,
                    cursorColor: AppColors.textColor,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        focusedBorder: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.flag,
                          color: AppColors.textColor,
                        ),
                        hintText: 'Enter your state',
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
                    _profileBloc.add(UpdateProfileEvent(state: _stateController.text));
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
