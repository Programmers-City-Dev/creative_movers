import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final AuthBloc _authBloc = AuthBloc();

  // List<String> filterlist = [];
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: AppColors.lightBlue,
                          shape: const StadiumBorder()),
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
                      margin: const EdgeInsets.all(5),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            // _controller.clear();
                            selectedList.add(_controller.text);
                            _controller.clear();
                          });
                        },
                        style: TextButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: AppColors.lightBlue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                        ),
                        child: const Text('Add'),
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
              BlocBuilder<AuthBloc, AuthState>(
                bloc: _authBloc,
                builder: (context, state) {
                  if (state is CategoryLoadingState) {
                    return Container(
                      child: Column(
                        children: const [
                          SizedBox(
                            height: 100,
                          ),
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text('Fetching Categories..')
                        ],
                      ),
                    );
                  } else if (state is CategorySuccessState) {
                    filterlist = state.categoriesReponse.category!;

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedList.add(filterlist[index]);
                              filterlist.remove(filterlist[index]);
                              print(selectedList);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              filterlist[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      itemCount: filterlist.length,
                      shrinkWrap: true,
                    );
                  } else {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        const Text('Ooops an error occured '),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomButton(
                          onTap: () {
                            _authBloc.add(CategoriesEvent());
                          },
                          child: const Text('Retry'),
                        )
                      ],
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _authBloc.add(CategoriesEvent());
  }
}

// Icon(
// Icons.done_rounded,
// color: AppColors.primaryColor,
// )
