import 'package:creative_movers/data/remote/model/search_response.dart';
import 'package:creative_movers/screens/main/search/widget/result_item.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({Key? key, required this.searchResponse}) : super(key: key);
  final SearchResponse searchResponse;


  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> with AutomaticKeepAliveClientMixin{
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
              widget.searchResponse.users.isNotEmpty?
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.searchResponse.users.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) =>  ResultItem(result: widget.searchResponse.users[index],),
                ),
              ):
                  Expanded(child: Center(child: Text('No results for your search..'),))
            ],
          ),
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
