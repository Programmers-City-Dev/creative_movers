import 'dart:developer';

import 'package:creative_movers/blocs/connects/conects_bloc.dart';
import 'package:creative_movers/models/get_connects_response.dart';
import 'package:creative_movers/screens/main/contacts/widgets/add_contacts_widget.dart';
import 'package:creative_movers/screens/main/contacts/widgets/contact_item.dart';
import 'package:creative_movers/screens/widget/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contact_screen.dart';

class ConnectsTab extends StatefulWidget {
  final List<Datum> data;

  const ConnectsTab({Key? key, required this.data}) : super(key: key);

  @override
  _ConnectsTabState createState() => _ConnectsTabState();
}

class _ConnectsTabState extends State<ConnectsTab> {
  List<Datum>? filterList;
  List<Datum>? mainList;

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
          return const Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        } else if (state is ConnectsSuccesState) {
          mainList = state.getConnectsResponse.connections.data;
          filterList = state.getConnectsResponse.connections.data;
          return Container(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Container(
                  child: SearchField(
                    hint: 'Search Contacts',
                    onChanged: (val) {
                      setState(() {
                        log(mainList!.length.toString());
                        filterList = mainList
                            ?.where((element) =>
                                (element.firstname.contains(val!)) |
                                (element.lastname.contains(val)))
                            .toList();
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                filterList!.isEmpty
                    ? const Expanded(child: Center(child: AddContactsWidget()))
                    : Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: filterList!.length,
                            itemBuilder: (context, index) =>
                                ContactItem(connection: filterList![index])))
              ],
            ),
          );
        } else if (state is ConnectsFailureState) {
          return Expanded(
              child: ErrorScreen(
            message: state.error,
            bloc: _connectsBloc,
          ));
        }
        return Container();
      },
    );
  }
}
