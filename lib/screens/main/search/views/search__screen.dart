import 'package:creative_movers/blocs/connects/conects_bloc.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/auth/widgets/search_dropdown.dart';
import 'package:creative_movers/screens/main/search/views/search_result_screen.dart';
import 'package:creative_movers/screens/widget/search_field.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final _searchValueController = TextEditingController();
  final ConnectsBloc _connectsBloc = ConnectsBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.smokeWhite,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        title: const Text(
          'Search Users',
          style: TextStyle(color: AppColors.textColor, fontSize: 16),
        ),
      ),
      body: BlocListener<ConnectsBloc, ConnectsState>(
        bloc: _connectsBloc,
        listener: (context, state) {
          _listenToSearchState(context,state);
        },
        child: SafeArea(
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
                   SearchField(
                    hint: 'Find Creators or Movers',
                    controller: _searchValueController,

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
                            userType = 'mover';
                          });
                        },
                        child: Chip(
                            backgroundColor: userType == 'mover'
                                ? AppColors.primaryColor
                                : Colors.grey.shade300,
                            label: Text(
                              'Movers',
                              style: TextStyle(
                                  color: userType == 'mover'
                                      ? AppColors.white
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
                                      ? AppColors.white
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
                                      ? AppColors.white
                                      : AppColors.textColor),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Business Category',
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
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              SearchDropdown(
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
                            (index) =>
                            Chip(
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
                    labels:
                    RangeLabels(' ${_values.start}', '${_values.start}'),
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
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
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 12)),
                              onPressed: () {
                                search();
                                // Navigator.of(context).push(MaterialPageRoute(
                                //   builder: (context) => SearchResultScreen(),
                                // ));
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
      ),
    );
  }


void search(){
      _connectsBloc.add(SearchEvent(userType, _searchValueController.text));
}


  void _listenToSearchState(BuildContext context, ConnectsState state) {
    if (state is SearchLoadingState) {
      AppUtils.showAnimatedProgressDialog(context);
    }
    if (state is SearchSuccesState) {
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchResultScreen(searchResponse: state.searchResponse,),));
    }
    if (state is SearchFailureState) {
      Navigator.pop(context);
      AppUtils.showCustomToast(state.error);
    }
  }
}
