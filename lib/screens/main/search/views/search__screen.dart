import 'package:creative_movers/screens/auth/widgets/search_dropdown.dart';
import 'package:creative_movers/screens/main/search/views/search_result_screen.dart';
import 'package:creative_movers/screens/widget/search_field.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> categories = [];
  RangeValues _values = RangeValues(10, 50);
  TextEditingController from_controller = TextEditingController();
  TextEditingController to_controller = TextEditingController();
  String userType = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.smokeWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        title: const Text(
          'Search Users',
          style: TextStyle(color: AppColors.textColor, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                const SearchField(

                  hint: 'Find Creators or Movers',
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'User Type',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          userType = 'movers';
                        });
                      },
                      child: Chip(
                          backgroundColor: userType == 'movers'
                              ? AppColors.primaryColor
                              : Colors.grey.shade300,
                          label: Text(
                            'Movers',
                            style: TextStyle(
                                color: userType == 'movers'
                                    ? Colors.white
                                    : AppColors.textColor),
                          )),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          userType = 'creative';
                        });
                      },
                      child: Chip(
                          backgroundColor: userType == 'creative'
                              ? AppColors.primaryColor
                              : Colors.grey.shade300,
                          label: Text(
                            'Creative',
                            style: TextStyle(
                                color: userType == 'creative'
                                    ? Colors.white
                                    : AppColors.textColor),
                          )),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          userType = 'all';
                        });
                      },
                      child: Chip(
                          backgroundColor: userType == 'all'
                              ? AppColors.primaryColor
                              : Colors.grey.shade300,
                          label: Text(
                            'All',
                            style: TextStyle(
                                color: userType == 'all'
                                    ? Colors.white
                                    : AppColors.textColor),
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Buisness Category',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.textColor),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text('Select Category'),
                      ),
                      width: MediaQuery.of(context).size.width,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => SearchDropdown(
                          onSaved: (list) {
                            setState(() {
                              categories = list;
                            });
                          },
                        ),
                      );
                    }),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 5,
                  children: List<Widget>.generate(
                      categories.length,
                      (index) => Chip(
                            label: Text(categories[index]),
                            deleteIcon: const Icon(Icons.close),
                            onDeleted: () {
                              setState(() {
                                categories.remove(categories[index]);
                              });
                            },
                          )),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Estimated Capital/Investment Amount',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                RangeSlider(
                  labels: RangeLabels(' ${_values.start}', '${_values.start}'),
                  min: 1,
                  max: 5000,
                  onChanged: (val) {
                    setState(() {
                      _values = val;
                      from_controller.text = _values.start.round().toString();
                      to_controller.text = _values.end.round().toString();
                    });
                  },
                  values: _values,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: TextFormField(
                      controller: from_controller,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefix: Text('\$'),
                        border: OutlineInputBorder(),
                        hintText: 'From',
                        contentPadding: EdgeInsets.all(8),
                      ),
                    )),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: TextFormField(
                      controller: to_controller,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          prefix: Text('\$'),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(8),
                          hintText: 'To'),
                    )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12)),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchResultScreen(),));
                            },
                            child: const Text(
                              'Search',
                              style: TextStyle(fontSize: 16),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
