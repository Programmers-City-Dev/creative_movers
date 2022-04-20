import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../../blocs/profile/profile_bloc.dart';
import '../../../../data/remote/model/register_response.dart';
import '../../../../di/injector.dart';
import '../../../../helpers/app_utils.dart';
import '../../../../theme/app_colors.dart';
import '../../../widget/custom_button.dart';
class EditEthnicityDialog extends StatefulWidget {
  final Function(User user ) onSuccess;
  final String? initialEthnicity;
  const EditEthnicityDialog({Key? key, required this.onSuccess, this.initialEthnicity}) : super(key: key);

  @override
  _EditEthnicityDialogState createState() => _EditEthnicityDialogState();
}
final _ethnicityController = TextEditingController();
final GlobalKey<FormState> _fieldKey = GlobalKey<FormState>();
final _profileBloc = ProfileBloc(injector.get());

class _EditEthnicityDialogState extends State<EditEthnicityDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ethnicityController.text = widget.initialEthnicity ?? '';
  }
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
              "Ethnicity has been updated successfully");
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
                'Edit ethnicity',
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
                      RequiredValidator(errorText: 'Enter your ethnic group'),
                      // EmailValidator(errorText: 'Enter a valid email'),
                    ]),

                    controller: _ethnicityController,
                    cursorColor: AppColors.textColor,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        focusedBorder: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.groups,
                          color: AppColors.textColor,
                        ),
                        hintText: 'Enter your ethnic group',
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
                    _profileBloc.add(UpdateProfileEvent(ethnicity: _ethnicityController.text));
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
