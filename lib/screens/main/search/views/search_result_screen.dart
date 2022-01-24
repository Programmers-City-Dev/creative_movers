import 'package:creative_movers/screens/main/search/widget/result_item.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({Key? key}) : super(key: key);

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: AppColors.textColor),
          title: const Text(
            'Search Result',
            style: TextStyle(color: AppColors.textColor, fontSize: 16),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 55,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => const ResultItem(),
                ),
              )
            ],
          ),
        ));
  }
}
