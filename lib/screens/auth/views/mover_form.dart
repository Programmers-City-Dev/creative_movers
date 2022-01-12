import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';

class MoverForm extends StatefulWidget {
  const MoverForm({Key? key}) : super(key: key);

  @override
  _MoverFormState createState() => _MoverFormState();
}

class _MoverFormState extends State<MoverForm> {
  GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
  List<String> selectedCategories = [];
  List<String> categories = [
    'Information Technology',
    'Agriculture',
    'Health',
    'Sports',
    'Oil and Gas',
    'Oil and Gas',
    'Oil and Gas',
    'Fashion And Design ',
    'Industrialization'
  ];
  List<String> plans = [
    '500 - below',
    '501 - 2000',
    '2001 - 5000',
    '5000 - above'
  ];
  List<String> stages = [
    'pre-seed (idea)',
    'Seed',
    'Early Start up',
    'Expansion (Growth)'
  ];
  String _groupValue = '';
  String _preferedStage = '';

  @override
  Widget build(BuildContext context) {
    return Form(
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
                    'Select Preffered Investment Range',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FormField<String>(
                    initialValue: _groupValue,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (value) {
                      // return 'selext';
                      if (_groupValue.isEmpty) {
                        return 'Please choose a range';
                      }
                      // return 'hh';

                      // if (value!.isEmpty ) {
                      //   return 'Please select some categories';
                      // }
                      // if (value!.length > 5) {
                      //   return "Can't select more than 5 categories";
                      // }
                      // return null;
                    },
                    builder: (_state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RadioGroup<String>.builder(
                            activeColor: AppColors.chipsColor,
                            groupValue: _groupValue,
                            onChanged: (value) {
                              setState(() {
                                _groupValue = value!;
                              });
                            },
                            items: plans,
                            itemBuilder: (value) => RadioButtonBuilder(value,
                                textPosition: RadioButtonTextPosition.right),
                          ),
                          Text(
                            _state.hasError ? _state.errorText! : '',
                            style: TextStyle(
                                color: _state.hasError
                                    ? Colors.redAccent
                                    : Colors.green),
                          )
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'What categories of investment \nare you interested in ?',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  Column(children: [
                    FormField<List<String>>(
                        autovalidateMode: AutovalidateMode.always,
                        initialValue: selectedCategories,
                        validator: (val) {
                          if (selectedCategories.isEmpty) {
                            return 'Select at least on category';
                          }
                        },
                        builder: (state) {
                          return
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ChipsChoice<String>.multiple(
                                //   // spinnerColor: AppColors.primaryColor,

                                //     choiceActiveStyle: const C2ChoiceStyle(
                                //         brightness: Brightness.dark,
                                //         color: AppColors.chipsColor),
                                //     choiceStyle: const C2ChoiceStyle(
                                //         showCheckmark: false),
                                //     padding: const EdgeInsets.symmetric(
                                //         horizontal: 0, vertical: 16),
                                //     wrapped: true,
                                //     value: selectedCategories,
                                //     onChanged: (value) {
                                //       setState(() {
                                //         selectedCategories = value;
                                //       });
                                //     },
                                //     choiceItems: C2Choice.listFrom<
                                //         String,
                                //         String>(
                                //       source: categories,
                                //       value: (i, v) => v,
                                //       label: (i, v) => v,
                                //     )),
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
                    'Preffered stage of investment',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  FormField<String>(
                    autovalidateMode: AutovalidateMode.always,
                    validator: (value) {
                      if (_preferedStage.isEmpty) {
                        return 'select a preferred stage';
                      }
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
                          SizedBox(
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
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            )),
            CustomButton(
              onTap: () {
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
    );
  }
}
