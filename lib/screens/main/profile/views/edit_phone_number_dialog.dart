import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../../theme/app_colors.dart';
import '../../../widget/custom_button.dart';
class EditPhoneNumberDialog extends StatefulWidget {
  const EditPhoneNumberDialog({Key? key}) : super(key: key);

  @override
  _EditPhoneNumberDialogState createState() => _EditPhoneNumberDialogState();
}

class _EditPhoneNumberDialogState extends State<EditPhoneNumberDialog> {
  final _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _fieldKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(

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

                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom),
              child: Form(
                key: _fieldKey,
                child: TextFormField(
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Email is required'),
                    EmailValidator(errorText: 'Enter a valid email'),
                  ]),

                  controller: _phoneNumberController,
                  cursorColor: AppColors.textColor,
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
              onTap:(){

                if(_fieldKey.currentState!.validate()){
                  // _authBloc.add(ForgotPasswordEvent(email: _phoneNumberController.text));

                }

              },
              child:const Text('Continue'),
            )
          ],
        ),
      ),
    );
  }
}
