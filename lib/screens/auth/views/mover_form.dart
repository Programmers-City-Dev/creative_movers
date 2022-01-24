import 'package:creative_movers/screens/auth/widgets/search_dropdown.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_radio_button/group_radio_button.dart';

import 'connection_screen.dart';

class MoverForm extends StatefulWidget {
  const MoverForm({Key? key}) : super(key: key);

  @override
  _MoverFormState createState() => _MoverFormState();
}

class _MoverFormState extends State<MoverForm> {
  GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
  List<String> selectedCategories = [];
  List<String> categories = [];
  List<String> plans = [
    '500 - below',
    '501 - 2000',
    '2001 - 5000',
    '5000 - above',
    'Other'
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
                        'Select Preferred Investment Range',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
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
                                itemBuilder: (value) =>
                                    RadioButtonBuilder(value,
                                        textPosition: RadioButtonTextPosition
                                            .right),
                              ),
                              SizedBox(height: 10,),
                              AnimatedContainer(

                                duration: Duration(milliseconds: 2000),
                                child: Visibility(
                                    visible: _groupValue == 'Other',
                                    child: Row(children: [
                                      const SizedBox(width: 20,),
                                      Expanded(child: TextFormField(
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        keyboardType: TextInputType.number ,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            contentPadding:EdgeInsets.all(8),
                                        hintText: 'From'
                                        ),)),
                                      const SizedBox(width: 16,),
                                      Expanded(child: TextFormField(
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        keyboardType: TextInputType.number ,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            contentPadding:EdgeInsets.all(8),
                                            hintText: 'To'
                                        ),)),
                                    ],)),
                              ),
                              const SizedBox(height: 16,),
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
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      const Text(
                        'What categories of investment \nare you interested in ?',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      Column(
                        children: [
                          FormField<List<String>>(
                              autovalidateMode: AutovalidateMode.always,
                              initialValue: categories,
                              validator: (val) {
                                if (categories.isEmpty) {
                                  return 'Select at least one category';
                                }
                              },
                              builder: (state) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    SizedBox(height: 10,),
                                    InkWell(
                                        child: Container(

                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppColors.textColor),
                                          ),

                                          child: const Padding(
                                            padding: EdgeInsets.all(18.0),
                                            child: Text('Select Category'),
                                          ),

                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                        ),
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                SearchDropdown(onSaved: (list) {
                                                  setState(() {
                                                    categories = list;
                                                  });
                                                },),
                                          );
                                        }),
                                    SizedBox(height: 10,),
                                    Wrap(
                                      alignment: WrapAlignment.start,
                                      runAlignment: WrapAlignment.start,
                                      direction: Axis.horizontal,
                                      spacing: 5,
                                      children: List<Widget>.generate(
                                          categories.length,
                                              (index) =>
                                              Chip(
                                                label: Text(categories[index]),
                                                deleteIcon: const Icon(
                                                    Icons.close),
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
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
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
                                itemBuilder: (value) =>
                                    RadioButtonBuilder(value,
                                        textPosition: RadioButtonTextPosition
                                            .right),
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ConnectionScreen(),));

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
