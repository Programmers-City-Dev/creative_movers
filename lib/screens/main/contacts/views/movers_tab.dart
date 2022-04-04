import 'package:creative_movers/blocs/connects/conects_bloc.dart';
import 'package:creative_movers/data/remote/model/get_connects_response.dart';
import 'package:creative_movers/screens/main/contacts/widgets/add_contacts_widget.dart';
import 'package:creative_movers/screens/main/contacts/widgets/connects_shimer.dart';
import 'package:creative_movers/screens/main/contacts/widgets/contact_item.dart';
import 'package:creative_movers/screens/widget/error_widget.dart';
import 'package:creative_movers/screens/widget/search_field.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectsTab extends StatefulWidget {


  const ConnectsTab({Key? key, }) : super(key: key);

  @override
  _ConnectsTabState createState() => _ConnectsTabState();
}

class _ConnectsTabState extends State<ConnectsTab>
    with AutomaticKeepAliveClientMixin {
  List<Connection> filterList = [];
  List<Connection> mainList = [];

  ConnectsBloc _connectsBloc = ConnectsBloc();

  @override
  void initState() {
    _connectsBloc.add(GetConnectsEvent());
    super.initState();
  }

  // @override
  // void initState() {
  //   mData = widget.data;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectsBloc, ConnectsState>(
      bloc: _connectsBloc,
      builder: (context, state) {
        if (state is ConnectsLoadingState) {
          return Column(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: 4,
                  itemBuilder: (context, index) => ConnectsShimer(),
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 14,
                    );
                  },
                ),
              )),
            ],
          );
        } else if (state is ConnectsSuccesState) {
          if (mainList.isEmpty) {
            filterList = state.getConnectsResponse.connections.connectionList;
            mainList = state.getConnectsResponse.connections.connectionList;
          }

          return Container(
            padding: const EdgeInsets.all(18),
            child: RefreshIndicator(
              onRefresh: () async{
                _connectsBloc.add(GetConnectsEvent());
                // return Future.delayed(const Duration(milliseconds: 1));
              },
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: SearchField(
                      hint: 'Search Contacts',
                      onChanged: (val) {
                        setState(() {
                          filterList = mainList
                              .where((element) =>
                                  element.firstname
                                      .toString()
                                      .toLowerCase()
                                      .contains(val.toString().toLowerCase()) |
                                  element.lastname
                                      .toLowerCase()
                                      .contains(val.toString().toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  filterList.isEmpty
                      ?Expanded(
                      child: Center(
                          child: AppPromptWidget(
                            onTap: () {  _connectsBloc.add(GetConnectsEvent());},
                            canTryAgain: true,
                            isSvgResource: true,
                            imagePath: "assets/svgs/request.svg",
                            title: "You have no connection yet .",
                            message: "Invite your contacts or search for connecions to start moving!",
                          )))
                      : Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: filterList.length,
                              itemBuilder: (context, index) =>
                                  ContactItem(connection: filterList[index])))
                ],
              ),
            ),
          );
        } else if (state is ConnectsFailureState) {
          return AppPromptWidget(
            // title: "Something went wrong",
            isSvgResource: true,
            message: state.error,
            onTap: () {
              _connectsBloc.add(GetConnectsEvent());
            },
          );
        }
        return Container();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
