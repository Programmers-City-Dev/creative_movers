import 'package:creative_movers/screens/auth/widgets/search_dropdown.dart';
import 'package:creative_movers/screens/widget/add_image_wigdet.dart';
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
  List<String> categories = [];
  @override
  Widget build(BuildContext context) {
    return Form(child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(children:  [
        AddImageWidget(),
        SizedBox(
          height: 10,
        ),
        Text(
          'Add Image to this page ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Use Images that represent what he page is all about '
              'like logo , This will appear in the search result',
          style: TextStyle(fontSize: 13),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 16,
        ),
        const FilledFormField( hint: 'Enter the name of this page'),
        const SizedBox(height: 10,),
        const FilledFormField( hint: 'Website Address (optional)'),
        const SizedBox(height: 10,),
        const FilledFormField( hint: 'Contact Info'),
        const SizedBox(height: 10,),
        InkWell(
            child: Container(

              decoration: const BoxDecoration(
                color: Colors.white
              ),

              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Select Category Of Investment'),
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
      ],),
    ));
  }
}
