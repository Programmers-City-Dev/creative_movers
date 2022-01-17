import 'dart:ffi';

import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SearchDropdown extends StatefulWidget {
  final void Function(List<String>)? onSaved;

  const SearchDropdown({
    Key? key,
    this.onSaved,
  }) : super(key: key);

  @override
  _SearchDropdownState createState() => _SearchDropdownState();
}

class _SearchDropdownState extends State<SearchDropdown> {
  List<String> categories = [
    'Information Technology',
    'Agriculture',
    'Health',
    'Sports',
    'Oil and Gas',
    'Oil and Gas',
    'Oil and Gas',
    'Fashion And Design ',
    'Industrialization'
  ];
  static const List<String> mcategories = [
    'Information Technology',
    'Agriculture',
    'Health',
    'Sports',
    'Oil and Gas',
    'Oil and Gas',
    'Oil and Gas',
    'Fashion And Design ',
    'Industrialization'
  ];
  List<String> filterlist = List.empty();
  List<String> selectedList = [];

  // List<String> filterlist = [];
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: AppColors.lightBlue,
                          shape: StadiumBorder()),
                      onPressed: () {
                        widget.onSaved!(selectedList);
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'SAVE',
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: AppColors.lightred,
                          shape: const StadiumBorder()),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'CANCEL',
                          style: TextStyle(color: AppColors.red),
                        ),
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                direction: Axis.horizontal,
                spacing: 5,
                children: List<Widget>.generate(
                    selectedList.length,
                    (index) => Chip(
                          label: Text(selectedList[index]),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () {
                            print(mcategories.contains(selectedList[index]));
                            print(selectedList[index]);

                            setState(() {
                              if (mcategories.contains(selectedList[index])) {
                                filterlist.add(selectedList[index]);
                                selectedList.remove(selectedList[index]);
                              } else {
                                selectedList.remove(selectedList[index]);
                              }
                            });
                          },
                        )),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                  suffixIcon: Visibility(
                    visible: _controller.text.isNotEmpty,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            // _controller.clear();
                            selectedList.add(_controller.text);
                            _controller.clear();
                          });
                        },
                        child: const Text('Add'),
                        style: TextButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: AppColors.lightBlue,
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  hintText: 'Search Category  ',
                  border: const OutlineInputBorder(),
                  focusColor: AppColors.textColor,
                ),
                controller: _controller,
                onSubmitted: (val) {
                  setState(() {
                    // _controller.clear();
                    selectedList.add(val);
                    _controller.clear();
                  });
                },
                onChanged: (val) {
                  setState(() {
                    filterlist = categories
                        .where((element) => element
                            .toLowerCase()
                            .contains(_controller.text.toLowerCase()))
                        .toList();
                  });
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedList.add(filterlist[index]);
                        filterlist.remove(filterlist[index]);
                        print(selectedList);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        filterlist[index],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                itemCount: filterlist.length,
                shrinkWrap: true,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    filterlist = categories;
  }
}



// Icon(
// Icons.done_rounded,
// color: AppColors.primaryColor,
// )