import 'package:creative_movers/models/get_connects_response.dart';
import 'package:creative_movers/screens/main/contacts/widgets/add_contacts_widget.dart';
import 'package:creative_movers/screens/main/contacts/widgets/contact_item.dart';
import 'package:creative_movers/screens/widget/search_field.dart';
import 'package:flutter/material.dart';

class MoversTab extends StatefulWidget {
  final List<Datum> data;

  const MoversTab({Key? key, required this.data}) : super(key: key);

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
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: const SearchField(
              hint: 'Search Contacts',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          widget.data.isEmpty
              ? Expanded(child: Center(child: const AddContactsWidget()))
              : Expanded(
                  child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.data.length,
                  itemBuilder: (context, index) => ContactItem(
                    connection: widget.data[index],
                  ),
                ))
        ],
      ),
    );
  }
}
