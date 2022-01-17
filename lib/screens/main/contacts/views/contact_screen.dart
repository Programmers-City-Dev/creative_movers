import 'package:creative_movers/screens/main/contacts/views/movers_tab.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

        length: 3,
        child: Column(
          children: [
            TabBar(

              padding: EdgeInsets.symmetric(horizontal:20 ),
              isScrollable: false,
              indicatorPadding: EdgeInsets.all(7),
              indicator: BoxDecoration(color: Colors.white,shape: BoxShape.rectangle,borderRadius:
              BorderRadius.circular(16)),
                labelColor: AppColors.primaryColor
                ,
                tabs: const [
                  Tab(

                    text: 'Creatives',

                  ),
              Tab(

                text: 'Mover',

              ),
              Tab(

                text: 'All',
              ),
            ]),
            Expanded(child: TabBarView(children: [MoversTab(),MoversTab(),MoversTab()]))
          ],
        ));
  }
}
