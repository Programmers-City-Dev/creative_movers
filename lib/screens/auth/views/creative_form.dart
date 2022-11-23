import 'dart:developer';
import 'dart:io';

import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:creative_movers/screens/main/payment/views/payment_screen.dart';
import 'package:creative_movers/screens/auth/widgets/search_dropdown.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:creative_movers/theme/style/app_styles.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'connection_screen.dart';

class CreativeForm extends StatefulWidget {
  final List<String> categories;
  const CreativeForm({Key? key, required this.categories}) : super(key: key);

  @override
  _CreativeFormState createState() => _CreativeFormState();
}

class _CreativeFormState extends State<CreativeForm> {
  List<String> selectedCategories = [];

  List<String> stages = ['Pre-seed', 'Seed', 'Start up', 'Expansion'];
  String cat = '';
  String stage = 'Seed';
  String image = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _capitalController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pagenameController = TextEditingController();

  // final _bioDataController = TextEditingController();
  final AuthBloc _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        _listenToAccountTypeState(context, state);
      },
      child: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      controller: _pagenameController,
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: 'Please enter your first buisness page'),
                      ]),
                      decoration: AppStyles.labeledFieldDecoration(
                          label: 'Create your first buisness page',
                          hintText: 'Create your first buisness page')),
                  const SizedBox(
                    height: 16,
                  ),
                  DropdownButtonFormField<String>(
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText:
                                'Please select the stage of your investment'),
                      ]),
                      onChanged: (value) {
                        stage = value!;
                      },
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.textColor)),
                          labelStyle: TextStyle(color: AppColors.textColor),
                          labelText: 'Select stage of investment',
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder()),
                      value: 'Seed',
                      items: stages
                          .map((e) => DropdownMenuItem<String>(
                              value: e, child: Text(e)))
                          .toList()),
                  const SizedBox(
                    height: 10,
                  ),
                  FormField<List<String>>(
                    initialValue: selectedCategories,
                    validator: ((value) {
                      if (selectedCategories.isEmpty) {
                        return 'Please select your category of investment';
                      }
                      return null;
                    }),
                    builder: (field) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.textColor),
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: const Padding(
                                padding: EdgeInsets.all(18.0),
                                child: Text('Select Category'),
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => SearchDropdown(
                                  onSaved: (list) {
                                    setState(() {
                                      selectedCategories = list;
                                    });
                                  },
                                ),
                              );
                            }),
                        Wrap(
                          alignment: WrapAlignment.start,
                          runAlignment: WrapAlignment.start,
                          direction: Axis.horizontal,
                          spacing: 5,
                          children: List<Widget>.generate(
                              selectedCategories.length,
                              (index) => Chip(
                                    label: Text(selectedCategories[index]),
                                    deleteIcon: const Icon(Icons.close),
                                    onDeleted: () {
                                      setState(() {
                                        selectedCategories
                                            .remove(selectedCategories[index]);
                                      });
                                    },
                                  )),
                        ),
                        Text(
                          field.hasError ? field.errorText! : '',
                          // ?? state.value?.length.toString()! + '/5 selected',
                          style: TextStyle(
                              color: field.hasError
                                  ? Colors.redAccent
                                  : Colors.green),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      controller: _descriptionController,
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText:
                                'Please write breif description of your buisness'),
                      ]),
                      maxLines: 5,
                      decoration: AppStyles.labeledFieldDecoration(
                          label: 'Brief description of your buisness',
                          hintText: 'Brief description of your buisness')),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText:
                                'Please select estimated capital needed for your investment'),
                      ]),
                      controller: _capitalController,
                      keyboardType: TextInputType.number,
                      decoration: AppStyles.labeledFieldDecoration(
                              label: 'Estimated capital needed',
                              hintText: 'Estimated capital needed')
                          .copyWith(
                              prefix: const Text(
                        '\$ ',
                        style: TextStyle(fontSize: 16),
                      ))),
                  const SizedBox(
                    height: 16,
                  ),
                  DottedBorder(
                    radius: const Radius.circular(5),
                    strokeWidth: 1,
                    borderType: BorderType.RRect,
                    child: SizedBox(
                      height: 170,
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: _fetchImage,
                            child: Container(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: AppColors.textColor,
                                      size: 55,
                                    ),
                                    Text(
                                        'Add Cover Image On YOur Buisness Page'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: _fetchImage,
                            child: ClipRRect(
                              child: Image.file(
                                File(image),
                                width: AppUtils.getDeviceSize(context).width,
                                height: 170,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  )
                ],
              ),
            ),
          )),
          Center(
            child: CustomButton(
              onTap: () {
                postAccountType();

                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => const ConnectionScreen(),
                // ));
              },
              child: const Text('Complete Registration'),
            ),
          ),
        ],
      ),
    );
  }

  void postAccountType() {
    if(image.isNotEmpty){
      if (_formKey.currentState!.validate()) {
        _authBloc.add(AccountTypeEvent(
            role: 'creative',
            name: _pagenameController.text,
            stage: stage,
            category: selectedCategories,
            est_capital: _capitalController.text,
            photo: image,
            description: _descriptionController.text));
      }

    }else{
      AppUtils.showCustomToast('Select Image',Colors.blue);
    }
  }

  void _listenToAccountTypeState(BuildContext context, AuthState state) {
    if (state is AccounTypeLoadingState) {
      AppUtils.showAnimatedProgressDialog(context);
    }

    if (state is AccountTypeFailureState) {
      Navigator.pop(context);
      log("Error creating creative account: ${state.error}",
          name: "CREATIVE FORM");
      CustomSnackBar.showError(context, message: state.error);
    }

    if (state is AccountTypeSuccesState) {
      Navigator.pop(context);
      StorageHelper.setBoolean(StorageKeys.stayLoggedIn, true);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => state.accountTypeResponse.connect.isNotEmpty
                ? ConnectionScreen(
                    connections: state.accountTypeResponse.connect,
                    role: state.accountTypeResponse.userRole?.role,
                  )
                : const PaymentScreen(
                    isFirstTime: true,
                  ),
          ),
          (route) => false);
    }
  }

  void _fetchImage() async {
    var images = await AppUtils.fetchImages(allowMultiple: false);
    if (images.isNotEmpty) {
      setState(() {
        image = images[0];
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
