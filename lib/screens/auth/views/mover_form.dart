import 'dart:developer';
import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:creative_movers/screens/main/payment/views/payment_screen.dart';
import 'package:creative_movers/screens/auth/widgets/search_dropdown.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'connection_screen.dart';

class MoverForm extends StatefulWidget {
  const MoverForm({Key? key, required this.categories}) : super(key: key);
  final List<String> categories;

  @override
  _MoverFormState createState() => _MoverFormState();
}

class _MoverFormState extends State<MoverForm>
    with AutomaticKeepAliveClientMixin {
  GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
  List<String> selectedCategories = [];
  List<String> categories = [];

  List<Map<String, String>> baseplans = [
    {'min': '1', 'max': '500'},
    {'min': '501', 'max': '2000'},
    {'min': '2001', 'max': '5000'},
    {'min': 'other', 'max': ''}
  ];

  Map<String, String> initialValue = {'min': '1', 'max': '500'};

  List<String> plans = [
    '500 - below',
    '501 - 2000',
    '2001 - 5000',
    '5000 - above',
    'Other'
  ];
  List<String> stages = ['Pre-seed', 'Seed', 'Start up', 'Expansion'];
  final String _groupValue = '';
  String _preferedStage = 'Seed';
  String? min = '';
  String? max = '';
  final _minController = TextEditingController();
  final _maxController = TextEditingController();
  final AuthBloc _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        _listenToAccountTypeState(context, state);
      },
      child: Form(
        key: myFormKey,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Select Preferred Investment Range',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FormField<Map<String, String>>(
                      initialValue: initialValue,
                      autovalidateMode: AutovalidateMode.disabled,
                      validator: (value) {
                        // return 'selext';
                        if (initialValue.isEmpty) {
                          return 'Please choose a range';
                        }
                        return null;
                        // return 'hh';

                        // if (value!.isEmpty ) {
                        //   return 'Please select some categories';
                        // }
                        // if (value!.length > 5) {
                        //   return "Can't select more than 5 categories";
                        // }
                        // return null;
                      },
                      builder: (state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RadioGroup<Map<String, String>>.builder(
                              activeColor: AppColors.chipsColor,
                              groupValue: initialValue,
                              onChanged: (value) {
                                initialValue = value!;
                                log(value.toString());
                                setState(() {
                                  if (value['min'] == 'other') {
                                    min = _minController.text.toString();
                                    max = _maxController.text.toString();
                                  } else {
                                    min = value['min'];
                                    max = value['max'];
                                    initialValue = value;
                                  }
                                });
                              },
                              items: baseplans,
                              itemBuilder: (value) => RadioButtonBuilder(
                                  value['min'] != 'other'
                                      ? '${value['min']} -  ${value['max']}'
                                      : 'other ',
                                  textPosition: RadioButtonTextPosition.right),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 2000),
                              child: Visibility(
                                  visible: initialValue['min'] == 'other',
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                          child: TextFormField(
                                        onChanged: (val) {
                                          setState(() {});
                                        },
                                        controller: _minController,
                                        validator: ((value) {
                                          if (initialValue['min'] == 'other' &&
                                              _minController.text.isEmpty) {
                                            return 'Enter your min  range';
                                          }
                                          return null;
                                        }),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            contentPadding: EdgeInsets.all(8),
                                            hintText: 'From'),
                                      )),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                          child: TextFormField(
                                        onChanged: (val) {
                                          setState(() {});
                                        },
                                        validator: ((value) {
                                          if (initialValue['min'] == 'other' &&
                                              _maxController.text.isEmpty) {
                                            return 'Enter your max  range';
                                          }
                                          return null;
                                        }),
                                        controller: _maxController,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            contentPadding: EdgeInsets.all(8),
                                            hintText: 'To'),
                                      )),
                                    ],
                                  )),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              state.hasError ? state.errorText! : '',
                              style: TextStyle(
                                  color: state.hasError
                                      ? Colors.redAccent
                                      : Colors.green),
                            )
                          ],
                        );
                      },
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    const Text(
                      'What categories of investment \nare you interested in ?',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    Column(
                      children: [
                        FormField<List<String>>(
                            autovalidateMode: AutovalidateMode.disabled,
                            initialValue: categories,
                            validator: (val) {
                              if (categories.isEmpty) {
                                return 'Select at least one category';
                              }
                              return null;
                            },
                            builder: (state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColors.textColor),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                                categories = list;
                                              });
                                            },
                                          ),
                                        );
                                      }),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    runAlignment: WrapAlignment.start,
                                    direction: Axis.horizontal,
                                    spacing: 5,
                                    children: List<Widget>.generate(
                                        categories.length,
                                        (index) => Chip(
                                              label: Text(categories[index]),
                                              deleteIcon:
                                                  const Icon(Icons.close),
                                              onDeleted: () {
                                                setState(() {
                                                  categories.remove(
                                                      categories[index]);
                                                });
                                              },
                                            )),
                                  ),
                                  Text(
                                    state.hasError ? state.errorText! : '',
                                    // ?? state.value?.length.toString()! + '/5 selected',
                                    style: TextStyle(
                                        color: state.hasError
                                            ? Colors.redAccent
                                            : Colors.green),
                                  )
                                ],
                              );
                            })
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Preferred stage of investment',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    FormField<String>(
                      autovalidateMode: AutovalidateMode.disabled,
                      validator: (value) {
                        if (_preferedStage.isEmpty) {
                          return 'select a preferred stage';
                        }
                        return null;
                      },
                      builder: (state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RadioGroup<String>.builder(
                              activeColor: AppColors.chipsColor,
                              groupValue: _preferedStage,
                              onChanged: (value) {
                                setState(() {
                                  _preferedStage = value!;
                                });
                              },
                              items: stages,
                              itemBuilder: (value) => RadioButtonBuilder(value,
                                  textPosition: RadioButtonTextPosition.right),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              state.hasError ? state.errorText! : '',
                              style: TextStyle(
                                  color: state.hasError
                                      ? Colors.redAccent
                                      : Colors.green),
                            )
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              )),
              CustomButton(
                onTap: () {
                  postAccountType();
                  // Navigator.of(context).push(MaterialPageRoute(
                  //   builder: (context) => const ConnectionScreen(),
                  // ));

                  if (myFormKey.currentState!.validate()) {
                    print('validated');
                  }
                },
                isEnabled: true,
                child: const Text('Complete Registration'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void postAccountType() {
    if (myFormKey.currentState!.validate()) {
      log(min!);
      _authBloc.add(AccountTypeEvent(
          role: 'mover',
          min_range: min,
          max_range: max,
          category: categories,
          stage: _preferedStage));
    }
  }

  void _listenToAccountTypeState(BuildContext context, AuthState state) {
    if (state is AccounTypeLoadingState) {
      AppUtils.showAnimatedProgressDialog(context);
    }

    if (state is AccountTypeFailureState) {
      Navigator.pop(context);
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
                : const PaymentScreen(isFirstTime: true,),
          ),
          (route) => false);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
