import 'package:creative_movers/screens/widget/search_field.dart';
import 'package:flutter/material.dart';

class UserConnectsScreen extends StatefulWidget {
  const UserConnectsScreen({Key? key}) : super(key: key);

  @override
  State<UserConnectsScreen> createState() => _UserConnectsScreenState();
}

class _UserConnectsScreenState extends State<UserConnectsScreen> {
  String filterValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SearchField(
            hint: 'Search Connects',
            radius: 16,
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Chip(
                label: const Text(
                  'Creatives',
                  style: TextStyle(color: Colors.grey),
                ),
                backgroundColor:
                    filterValue == 'Creatives' ? Colors.blue : Colors.white,
                side: const BorderSide(color: Colors.grey),
                shape: const StadiumBorder(),
              ),
              Chip(
                label: const Text(
                  'Movers',
                  style: TextStyle(color: Colors.grey),
                ),
                backgroundColor:
                    filterValue == 'Movers' ? Colors.blue : Colors.white,
                side: const BorderSide(color: Colors.grey),
                shape: const StadiumBorder(),
              ),
              Chip(
                label: const Text(
                  'All',
                  style: TextStyle(color: Colors.grey),
                ),
                backgroundColor:
                    filterValue == 'All' ? Colors.blue : Colors.white,
                side: const BorderSide(color: Colors.grey),
                shape: const StadiumBorder(),
              ),
            ],
          ),
          GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (ctx,index)=>Container())
        ],
      ),
    ));
  }
}
