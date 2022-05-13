import 'package:creative_movers/blocs/profile/profile_bloc.dart';
import 'package:creative_movers/data/remote/model/register_response.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/models/ethnicity.dart';
import 'package:creative_movers/screens/main/profile/widgets/profile_dialog.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/screens/widget/custom_dropdown_menu.dart';
import 'package:creative_movers/screens/widget/custom_dropdown_menu_tile.dart';
import 'package:creative_movers/screens/widget/ethnicity_dropdown_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UpdateEthnicity extends StatefulWidget {
  final Function(User) onSuccess;
  final String? defaultValue;

  const UpdateEthnicity({Key? key, required this.onSuccess, this.defaultValue})
      : super(key: key);

  @override
  _UpdateEthnicityState createState() => _UpdateEthnicityState();
}

class _UpdateEthnicityState extends State<UpdateEthnicity> {
  final GlobalKey<CustomDropdownMenuExpansionTileState> expansionTileKey =
      GlobalKey();
  String? _selectedEthnicity;
  final _profileBloc = ProfileBloc(injector.get());

  @override
  void initState() {
    _selectedEthnicity = widget.defaultValue ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileDialog(
      title: 'CHANGE ETHNICITY',
      builder: (context, dialogState) => Container(
        child: Column(
          children: [
            CustomDropdownMenu(
              label: 'Ethnicity',
              headTitle: _selectedEthnicity,
              items: AppUtils.ethnicities.map((item) {
                return EthnicityDropdownMenuItem<EthnicityModel>(
                    tileKey: expansionTileKey,
                    onSelect: (String value) {
                      setState(() {
                        _selectedEthnicity = value;
                      });
                    },
                    value: item,
                    selected: _selectedEthnicity);
              }).toList(),
              tileKey: expansionTileKey,
              onSelect: () {},
              value: _selectedEthnicity,
            ),
            const SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              child: BlocConsumer<ProfileBloc, ProfileState>(
                bloc: _profileBloc,
                listener: (context, state) {
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
                    AppUtils.showCustomToast(state.error);
                  }
                },
                builder: (context, state) {
                  return CustomButton(
                    onTap: (state is ProfileUpdateLoading)
                        ? null
                        : () {
                            if (_selectedEthnicity != null) {
                              _profileBloc.add(UpdateProfileEvent(
                                  ethnicity: _selectedEthnicity));
                              // _authBloc.add(ForgotPasswordEvent(email: _phoneNumberController.text));

                            }
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state is ProfileUpdateLoading)
                          const Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: SpinKitRotatingCircle(
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                        Text((state is ProfileUpdateLoading)
                            ? 'Updating'
                            : 'Update'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
