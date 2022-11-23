import 'dart:developer';

import 'package:creative_movers/data/remote/model/get_connects_response.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/main/profile/widgets/user_connection_card.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../blocs/connects/conects_bloc.dart';
import '../../../widget/error_widget.dart';
import '../../../widget/search_field.dart';

class UserConnectsScreen extends StatefulWidget {
  final String user_id;

  const UserConnectsScreen({Key? key, required this.user_id}) : super(key: key);

  @override
  State<UserConnectsScreen> createState() => _UserConnectsScreenState();
}

class _UserConnectsScreenState extends State<UserConnectsScreen> {
  String roleValue = 'All';
  List<Connection> filterList = [];
  List<Connection> mainList = [];
  List<Connection> searchFilter = [];
  final ConnectsBloc _connectsBloc = ConnectsBloc();
  final _searchController = TextEditingController();
  final currentpage = 1;

  @override
  void initState() {
    _connectsBloc.add(GetConnectsEvent(user_id: widget.user_id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0.5,
            title: const Text(
              'Connections',
              style: TextStyle(color: AppColors.black),
            ),
            automaticallyImplyLeading: true,
            iconTheme: const IconThemeData(color: AppColors.black),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: RefreshIndicator(
                onRefresh: () async {
                  _connectsBloc.add(GetConnectsEvent(user_id: widget.user_id));

                  // return Future.delayed(Duration(seconds: 1));
                },
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    SearchField(
                      hint: 'Search Connects',
                      radius: 16,
                      fillcolor: Colors.grey.shade100,
                      controller: _searchController,
                      onSubmitted: (val) {
                        log(widget.user_id);
                        _connectsBloc.add(SearchConnectsEvent(searchValue: _searchController.text,user_id: widget.user_id));
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              roleValue = 'Creative';
                            });
                            filterConnects(FilterParam(
                                role: roleValue, name: _searchController.text));
                          },
                          child: Chip(
                            label: Text(
                              'Creatives',
                              style: TextStyle(
                                color: roleValue == 'Creative'
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                            backgroundColor: roleValue == 'Creative'
                                ? Colors.blue
                                : AppColors.white,
                            side: BorderSide(color: Colors.grey.shade100),
                            shape: const StadiumBorder(),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              roleValue = 'Mover';
                            });
                            filterConnects(FilterParam(
                                role: roleValue, name: _searchController.text));
                          },
                          child: Chip(
                            label: Text(
                              'Movers',
                              style: TextStyle(
                                  color: roleValue == 'Mover'
                                      ? Colors.white
                                      : Colors.grey),
                            ),
                            backgroundColor: roleValue == 'Mover'
                                ? Colors.blue
                                : AppColors.white,
                            side: BorderSide(color: Colors.grey.shade100),
                            shape: const StadiumBorder(),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              roleValue = 'All';
                            });
                            filterConnects(FilterParam(
                                role: 'all', name: _searchController.text));
                          },
                          child: Chip(
                            label: Text(
                              'All',
                              style: TextStyle(
                                  color: roleValue == 'All'
                                      ? Colors.white
                                      : Colors.grey),
                            ),
                            backgroundColor:
                                roleValue == 'All' ? Colors.blue : Colors.white,
                            side: BorderSide(color: Colors.grey.shade100),
                            shape: const StadiumBorder(),
                          ),
                        ),
                      ],
                    ),
                    BlocConsumer<ConnectsBloc, ConnectsState>(
                      buildWhen: (prevState, currentState) {
                        return currentState is ConnectsLoadingState ||
                            currentState is ConnectsSuccesState ||
                            currentState is ConnectsFailureState;
                      },
                      listener: (ctx, state) {
                        if (state is ConnectsSuccesState) {
                          log(state.connectsResponse.connections.connectionList.length.toString());
                            filterList = state
                                .connectsResponse.connections.connectionList;
                            mainList = state
                                .connectsResponse.connections.connectionList;

                        }
                        if(state is ConnectsFailureState){
                          AppUtils.showCustomToast(state.error,Colors.red);
                        }

                      },
                      bloc: _connectsBloc,
                      builder: (context, state) {
                        if (state is ConnectsLoadingState) {
                          return Column(
                            children: [
                              GridView.builder(
                                itemCount: 7,
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.7),
                                itemBuilder: (ctx, index) => Shimmer.fromColors(
                                    baseColor: Colors.grey[200]!,
                                    highlightColor: Colors.grey[300]!,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      margin: const EdgeInsets.all(5),
                                    )),
                              ),
                            ],
                          );
                        } else if (state is ConnectsSuccesState) {
                          if (filterList.isEmpty) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 100,
                                ),
                                Center(
                                    child: AppPromptWidget(
                                  buttonText: 'Try again',
                                  onTap: () {
                                    _connectsBloc.add(const GetConnectsEvent());
                                  },
                                  canTryAgain: true,
                                  isSvgResource: true,
                                  imagePath: "assets/svgs/request.svg",
                                  title: "No connection  ",
                                  message:
                                      "Invite your contacts or search for connecions to start moving!",
                                )),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                GridView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics: const BouncingScrollPhysics(),
                                    // primary: false,
                                    shrinkWrap: true,
                                    itemCount: filterList.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10,
                                            childAspectRatio: 0.7),
                                    itemBuilder: (ctx, index) =>
                                        UserConnectionCard(
                                          connection: filterList[index],
                                        )),
                                Visibility(
                                  visible: state.connectsResponse.connections
                                          .nextPageUrl !=
                                      null,
                                  child: TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                        shape: const StadiumBorder(
                                            side: BorderSide(
                                                color: AppColors.primaryColor)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16)),
                                    child: const Text(
                                      'Load more',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.primaryColor),
                                    ),
                                  ),
                                )
                              ],
                            );
                          }
                        } else if (state is ConnectsFailureState) {
                          return AppPromptWidget(
                            // title: "Something went wrong",
                            isSvgResource: true,
                            message: state.error,
                            onTap: () {
                              _connectsBloc.add(const GetConnectsEvent());
                            },
                          );
                        } else {
                          return Container(
                            height: 44,
                            color: Colors.blue,
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void filterConnects(FilterParam filterParam) {
    setState(() {
      log(filterParam.role.toLowerCase());
      if (_searchController.text.isNotEmpty) {
        if (filterParam.role.toLowerCase() == 'all') {
          filterList = mainList
              .where((element) =>
                  element.firstname
                      .toLowerCase()
                      .contains(filterParam.name.toLowerCase()) ||
                  element.lastname
                      .toLowerCase()
                      .contains(filterParam.name.toLowerCase()) ||
                  element.username.contains(filterParam.name.toLowerCase()))
              .toList();
        } else {
          filterList = mainList
              .where((element) =>
                  element.role.toLowerCase() ==
                          filterParam.role.toLowerCase() &&
                      element.firstname
                          .toLowerCase()
                          .contains(filterParam.name.toLowerCase()) ||
                  element.lastname
                      .toLowerCase()
                      .contains(filterParam.name.toLowerCase()) ||
                  element.username.contains(filterParam.name.toLowerCase()))
              .toList();
        }
      } else {
        if (filterParam.role.toLowerCase() == 'all') {
          filterList = mainList
              .where((element) =>
                  element.firstname
                      .toLowerCase()
                      .contains(filterParam.name.toLowerCase()) ||
                  element.lastname
                      .toLowerCase()
                      .contains(filterParam.name.toLowerCase()) ||
                  element.username.contains(filterParam.name.toLowerCase()))
              .toList();
        } else {
          filterList = mainList
              .where((element) =>
                  element.role.toLowerCase() == filterParam.role.toLowerCase())
              .toList();
        }
      }
    });
  }
}

class FilterParam {
  String role;
  String name;

  FilterParam({required this.role, required this.name});
}
