import 'package:creative_movers/screens/widget/filled_form_field.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
class CreatePageForm extends StatefulWidget {
  const CreatePageForm({Key? key}) : super(key: key);

  @override
  _CreatePageFormState createState() => _CreatePageFormState();
}

class _CreatePageFormState extends State<CreatePageForm> {

  List<String> stages = [
    'Pre-seed(idea)',
    'Seed',
    'Early Start up',
    'Expansion'
  ];
  @override
  Widget build(BuildContext context) {
    return Form(child: Column(children:  [
      const FilledFormField( hint: 'Enter the name of this page'),
      const SizedBox(height: 10,),
      const FilledFormField( hint: 'Website Address (optional)'),
      const SizedBox(height: 10,),
      const FilledFormField( hint: 'Contact Info'),
      const SizedBox(height: 10,),
      DropdownButtonFormField<String>(
          onChanged: (value) {
            // cat = value!;
          },
          decoration:  const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
              labelStyle: TextStyle(color: AppColors.textColor),
              labelText: 'Select stage of investment',
              contentPadding: EdgeInsets.all(16),
              border: OutlineInputBorder(borderSide: BorderSide.none)),
          value: null,
          items: stages
              .map((e) =>
              DropdownMenuItem<String>(value: e, child: Text(e)))
              .toList()),
      const SizedBox(height: 10,),
      const FilledFormField( hint: 'Whats this page all about',maxlines: 5,),


      Container(
        margin: const EdgeInsets.symmetric(vertical: 18),

        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(

            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),

            onPressed: () {
            },
            child: const Text(
              'DONE',
              style: TextStyle(fontSize: 16),
            )),
      ),
    ],));
  }
}
