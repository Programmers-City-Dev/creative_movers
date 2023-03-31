import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/profile/profile_bloc.dart';
import '../../../../di/injector.dart';
import '../../../../helpers/app_utils.dart';
import '../../../../theme/app_colors.dart';
import '../../../widget/custom_button.dart';
class EditGenderDialog extends StatefulWidget {
  final Function(User) onSuccess;
  const EditGenderDialog({Key? key, required this.onSuccess}) : super(key: key);

  @override
  _EditGenderDialogState createState() => _EditGenderDialogState();
}

class _EditGenderDialogState extends State<EditGenderDialog> {
  final GlobalKey<FormState> _fieldKey = GlobalKey<FormState>();
  final _profileBloc = ProfileBloc(injector.get());
  List<String> genders = ['Male' , 'Female'];
  String gender = '';



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
              "Gender has been updated successfully");
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
                'Edit Gender',
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
                  child: DropdownButtonFormField<String>(
                      onChanged: (value) {
                        gender = value!;
                      },
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: AppColors.textColor)),
                          labelStyle: TextStyle(color: AppColors.textColor),
                          labelText: 'Select Gender',
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder()),
                      value: 'Male',
                      items: genders
                          .map((e) => DropdownMenuItem<String>(
                          value: e, child: Text(e)))
                          .toList()),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              CustomButton(
                onTap: () {
                  if (_fieldKey.currentState!.validate()) {
                    _profileBloc.add(UpdateProfileEvent(gender: gender));
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
