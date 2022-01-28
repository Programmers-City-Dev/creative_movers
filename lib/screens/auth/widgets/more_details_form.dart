import 'package:creative_movers/screens/auth/views/account_type_screen.dart';
import 'package:creative_movers/screens/auth/widgets/form_field.dart';
import 'package:creative_movers/screens/widget/add_image_wigdet.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:creative_movers/theme/style/app_styles.dart';
import 'package:flutter/material.dart';

class MoreDetailsForm extends StatefulWidget {
  const MoreDetailsForm({Key? key, required this.mainContext})
      : super(key: key);
  final BuildContext mainContext;

  @override
  _MoreDetailsFormState createState() => _MoreDetailsFormState();
}

class _MoreDetailsFormState extends State<MoreDetailsForm> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'More About Yourself',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    cursorColor: AppColors.textColor,
                    decoration: AppStyles.labeledFieldDecoration(
                        label: 'First Name', hintText: 'First Name'),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                      cursorColor: AppColors.textColor,
                      decoration: AppStyles.labeledFieldDecoration(
                          label: 'Last Name', hintText: 'Last Name')),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                      cursorColor: AppColors.textColor,
                      decoration: AppStyles.labeledFieldDecoration(
                          label: 'Phone Number', hintText: 'Phone Number')),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                      cursorColor: AppColors.textColor,
                      maxLines: 4,
                      decoration: AppStyles.labeledFieldDecoration(
                          label: 'Bio Data', hintText: 'Bio Data')),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomButton(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AccountTypeScreen(),
                      ));
                    },
                    child: const Text('Continue'),
                  )

                  // Container(decoration: ,)
                ],
                mainAxisSize: MainAxisSize.min,
              )),
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.blue, blurRadius: 30)],
              borderRadius: BorderRadius.only()),
        ),
        const Positioned(
            top: -50, left: 0, right: 0, child: Center(child: AddImageWidget()))
      ],
    );
  }
}
