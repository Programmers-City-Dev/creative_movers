import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:creative_movers/screens/auth/views/account_type_screen.dart';
import 'package:creative_movers/screens/widget/add_image_wigdet.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:creative_movers/theme/style/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

class MoreDetailsForm extends StatefulWidget {
  const MoreDetailsForm({Key? key, required this.mainContext})
      : super(key: key);
  final BuildContext mainContext;

  @override
  _MoreDetailsFormState createState() => _MoreDetailsFormState();
}

class _MoreDetailsFormState extends State<MoreDetailsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _bioDataController = TextEditingController();
  final AuthBloc _authBloc = AuthBloc();
  String image = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        _listenToBioDataState(context, state);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
                color: AppColors.white,
                boxShadow: [BoxShadow(color: Colors.blue, blurRadius: 30)],
                borderRadius: BorderRadius.only()),
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                            child: AddImageWidget(
                          onUpload: _fetchImage,
                          imagePath: image,
                        )),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          'More About Yourself',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _firstNameController,
                          cursorColor: AppColors.textColor,
                          decoration: AppStyles.labeledFieldDecoration(
                              label: 'First Name', hintText: 'First Name'),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'Please enter your first name'),
                          ]),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            controller: _lastNameController,
                            cursorColor: AppColors.textColor,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: 'Please enter your last name'),
                            ]),
                            decoration: AppStyles.labeledFieldDecoration(
                                label: 'Last Name', hintText: 'Last Name')),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.number,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: 'Please enter your Phone Number'),
                            ]),
                            cursorColor: AppColors.textColor,
                            decoration: AppStyles.labeledFieldDecoration(
                                label: 'Phone Number',
                                hintText: 'Phone Number')),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            controller: _bioDataController,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText:
                                      'Please enter a description about yourself'),
                            ]),
                            cursorColor: AppColors.textColor,
                            maxLines: 4,
                            decoration: AppStyles.labeledFieldDecoration(
                                label: 'Bio Data', hintText: 'Bio Data')),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomButton(
                          onTap: () {
                            _postBioData();
                            // Navigator.of(context).pushAndRemoveUntil(
                            //     MaterialPageRoute(
                            //       builder: (context) => AccountTypeScreen(),
                            //     ),
                            //         (route) => false);
                          },
                          child: const Text('Continue'),
                        )
                        // Container(decoration: ,)
                      ],
                    )),
              ),
            ),
          ),
          // Positioned(
          //    top: -50,
          //    left: 0,
          //    right: 0,
          //    child: Center(child: AddImageWidget(onUpload: _fetchImage,imagePath: image,)))
        ],
      ),
    );
  }

  void _postBioData() {
    if (_formKey.currentState!.validate()) {
      _authBloc.add(BioDataEvent(
          image: image.isNotEmpty ? image : null,
          firstname: _firstNameController.text.toString(),
          lastname: _lastNameController.text.toString(),
          phoneNumber: _phoneNumberController.text.toString(),
          biodata: _bioDataController.text.toString()));
    }
  }

  void _listenToBioDataState(BuildContext context, AuthState state) {
    if (state is BioDataLoadingState) {
      AppUtils.showAnimatedProgressDialog(context);
    }

    if (state is BioDataFailureState) {
      Navigator.pop(context);
      CustomSnackBar.showError(context, message: state.error);
    }

    if (state is BioDataSuccesState) {
      StorageHelper.setString(
          StorageKeys.firstname, _firstNameController.text.toString().trim());
      StorageHelper.setString(
          StorageKeys.lastname, _lastNameController.text.toString().trim());

      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) =>
                AccountTypeScreen(categories: state.bioDataResponse.category),
          ),
          (route) => false);
    }
  }

  void _fetchImage() async {
    var images = await AppUtils.fetchFiles(allowMultiple: false);
    if (images.isNotEmpty) {
      setState(() {
        image = images[0];
      });
    }
  }
}
