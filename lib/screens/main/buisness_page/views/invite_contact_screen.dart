import 'package:creative_movers/screens/main/buisness_page/widgets/contact_item.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class InviteContactScreen extends StatefulWidget {
  const InviteContactScreen({Key? key}) : super(key: key);

  @override
  _InviteContactScreenState createState() => _InviteContactScreenState();
}

class _InviteContactScreenState extends State<InviteContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invite Contacts',style: TextStyle(fontSize: 16),),),
      backgroundColor: AppColors.smokeWhite,
      body: Container(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                  itemCount: 5,
              shrinkWrap: true,
              itemBuilder: (context, index) => const ContactItem(),
            ))
          ],
        ),
      ),
    );
  }
}
