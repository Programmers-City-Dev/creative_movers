import 'package:creative_movers/helpers/paths.dart';
import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AddContactsWidget extends StatefulWidget {
  const AddContactsWidget({Key? key}) : super(key: key);

  @override
  _AddContactsWidgetState createState() => _AddContactsWidgetState();
}

class _AddContactsWidgetState extends State<AddContactsWidget> {
  List<String> placeholders = [
    AppIcons.icPlaceHolder1,
    AppIcons.icPlaceHolder2,
    AppIcons.icPlaceHolder3,
    AppIcons.icPlaceHolder4
  ];

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

        const SizedBox(height: 10,),
          SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: placeholders.length,
            itemBuilder: (context, index) => CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(placeholders[index]),
            ),
          ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              ' This  list is empty find out people you might love to connect to and grow your audience',
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12), backgroundColor: AppColors.primaryColor),
                onPressed: () {
                  Navigator.of(context).pushNamed(inviteContactsPath);
                },
                child: const Text(
                  'CONNECT',
                  style: TextStyle(fontSize: 16),
                )),
          )
         
        ],
      ),
    );
  }
}
