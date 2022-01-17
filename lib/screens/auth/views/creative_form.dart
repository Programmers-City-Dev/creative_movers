import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/auth/widgets/search_dropdown.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:creative_movers/theme/style/app_styles.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'connection_screen.dart';

class CreativeForm extends StatefulWidget {
  const CreativeForm({Key? key}) : super(key: key);

  @override
  _CreativeFormState createState() => _CreativeFormState();
}

class _CreativeFormState extends State<CreativeForm> {
  List<String> categories = [
  ];
  String cat = '';

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                  decoration:  AppStyles.labeledFieldDecoration(label: 'Create your first buisness page',hintText: 'Create your first buisness page')

              ),
              const SizedBox(
                height: 16,
              ),
              // DropdownButtonFormField<String>(
              //     onChanged: (value) {
              //       // cat = value!;
              //     },
              //     decoration: const InputDecoration(
              //         focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.textColor)),
              //         labelStyle: TextStyle(color: AppColors.textColor),
              //         labelText: 'Select Buisness Category',
              //         contentPadding: EdgeInsets.all(16),
              //         border: OutlineInputBorder()),
              //     value: null,
              //     items: categories
              //         .map((e) =>
              //             DropdownMenuItem<String>(value: e, child: Text(e)))
              //         .toList()),

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

              const SizedBox(
                height: 10,
              ),
              TextFormField(
                maxLines: 5,
                  decoration:  AppStyles.labeledFieldDecoration(label: 'Brief description of your buisness',hintText: 'Brief description of your buisness')

              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                  decoration:  AppStyles.labeledFieldDecoration(label: 'Estimated capital needed',hintText: 'Estimated capital needed')

              ),
              SizedBox(
                height: 16,
              ),
              DottedBorder(
                radius: const Radius.circular(5),
                strokeWidth: 1,
                borderType: BorderType.RRect,
                child: Container(
                  height: 170,
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          child: Center(
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: AppColors.textColor,
                                  size: 55,
                                ),
                                Text('Add Cover Immage On YOur Buisness Page'),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){},
                        child: Container(
                          decoration: BoxDecoration(
                              // image: const DecorationImage(
                              //     fit: BoxFit.cover,
                              //     image: AssetImage(AppIcons.imgSlide1))
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16,)
            ],
          ),
        )),
        Center(
          child: CustomButton(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ConnectionScreen(),));
            },
            child: const Text('Complete Registration'),
          ),
        ),
      ],
    ));
  }
}
