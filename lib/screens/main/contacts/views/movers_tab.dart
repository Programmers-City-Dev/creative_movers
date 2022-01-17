import 'package:creative_movers/screens/main/contacts/widgets/contact_item.dart';
import 'package:creative_movers/screens/widget/search_field.dart';
import 'package:flutter/material.dart';

class MoversTab extends StatefulWidget {
  const MoversTab({Key? key}) : super(key: key);

  @override
  _MoversTabState createState() => _MoversTabState();
}

class _MoversTabState extends State<MoversTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: SearchField(
              hint: 'Search Contacts',
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) => ContactItem(),
          ))
        ],
      ),
    );
  }
}
