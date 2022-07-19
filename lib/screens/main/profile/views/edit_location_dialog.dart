import 'dart:developer';

import 'package:creative_movers/blocs/profile/profile_bloc.dart';
import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class EditLocationDialog extends StatelessWidget {
  final Function(User user) onSuccess;
  final String? initialCountry;

  EditLocationDialog(
      {Key? key, required this.onSuccess, required this.initialCountry})
      : super(key: key);

  final _profileBloc = ProfileBloc(injector.get());

  String? countryValue;

  String? stateValue;

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
          log("USER:${state.updateProfileResponse.toJson()}");
          onSuccess(state.updateProfileResponse.user);
          Navigator.of(context).pop();
          // AppUtils.cancelAllShowingToasts();
          AppUtils.showCustomToast("Country  has been updated successfully");
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
              'Edit Location',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            CSCPicker(
              showStates: true,
              showCities: false,
              flagState: CountryFlag.ENABLE,
              dropdownDecoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1)),
              disabledDropdownDecoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey.shade300,
                  border: Border.all(color: Colors.grey.shade300, width: 1)),
              countrySearchPlaceholder: "Country",
              stateSearchPlaceholder: "State",
              citySearchPlaceholder: "City",

              ///labels for dropdown
              countryDropdownLabel: "*Country",
              stateDropdownLabel: "*State",

              ///Default Country
              defaultCountry: DefaultCountry.Nigeria,

              ///Disable country dropdown (Note: use it with default country)
              //disableCountry: true,

              ///selected item style [OPTIONAL PARAMETER]
              selectedItemStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),

              dropdownHeadingStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
              dropdownItemStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              dropdownDialogRadius: 10.0,
              searchBarRadius: 10.0,
              onCountryChanged: (value) {
                countryValue = value;
              },
              onStateChanged: (value) {
                stateValue = value;
              },
              onCityChanged: (value) {},
            ),
            const SizedBox(
              height: 15,
            ),
            CustomButton(
              onTap: () {
                if (countryValue != null && stateValue != null) {
                  _profileBloc.add(UpdateProfileEvent(
                      country: countryValue, state: stateValue));
                } else {
                  AppUtils.showErrorDialog(context,
                      message: "Please select the required fields.",
                      title: "Error",
                      confirmButtonText: "OK",
                      onConfirmed: () => Navigator.of(context).pop());
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
