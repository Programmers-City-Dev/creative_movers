import 'package:creative_movers/screens/auth/views/creative_form.dart';
import 'package:creative_movers/screens/auth/views/mover_form.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AccountTypeScreen extends StatefulWidget {
  const AccountTypeScreen({Key? key}) : super(key: key);

  @override
  _AccountTypeScreenState createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends State<AccountTypeScreen> {
  String account_type = '';
  bool isEnabled = false;
  List<String> items = ['Creative', 'Mover'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        // primary: false,

        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textColor,
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Select Account Type',
          style: TextStyle(color: AppColors.textColor),
        ),

      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              // const Text('User Type',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: AppColors.textColor),),
              const SizedBox(height: 20,),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    labelText: 'Select User Account Type',
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(

                        borderSide: BorderSide())),
                hint: const Text('Select Account Type'),
                value: null,
                onChanged: (value) {
                  setState(() {
                    account_type = value!;
                    isEnabled = true;
                  });
                },
                items: items.map((e) =>
                    DropdownMenuItem<String>(
                        value: e,
                        child: Text(e))).toList(),),
              SizedBox(height: 20,),
              Divider(),
              Expanded(child: account_type == 'Mover'
                  ? const MoverForm()
                  : account_type == 'Creative' ? CreativeForm():const Center(
                child: Text('Select Account Type to Continue'),)),
            ],)),
    );
  }
}
