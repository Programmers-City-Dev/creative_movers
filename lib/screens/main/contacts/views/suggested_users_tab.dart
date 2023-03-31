import 'dart:developer';

import 'package:creative_movers/blocs/connects/conects_bloc.dart';
import 'package:creative_movers/screens/main/contacts/widgets/connects_shimer.dart';
import 'package:creative_movers/screens/main/search/widget/result_item.dart';
import 'package:creative_movers/screens/widget/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SuggestedUsersTab extends StatefulWidget {
  const SuggestedUsersTab({Key? key}) : super(key: key);

  @override
  State<SuggestedUsersTab> createState() => _SuggestedUsersTabState();
}

class _SuggestedUsersTabState extends State<SuggestedUsersTab> with AutomaticKeepAliveClientMixin{
  final ConnectsBloc _connectsBloc = ConnectsBloc();

  @override
  void initState() {
    super.initState();
    _connectsBloc.add(GetSuggestedConnectsEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ConnectsBloc, ConnectsState>(
      bloc: _connectsBloc,
      // buildWhen: (previous, current) =>
      //     current is ConnectsLoadingState ||
      //     current is SuggestedConnectsSuccessState ||
      //     current is ConnectsFailureState,
      builder: (context, state) {
        log("SUGGESTION STATE: $state");
        if (state is ConnectsLoadingState) {
          return Column(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: 4,
                  itemBuilder: (context, index) => const ConnectsShimer(),
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 14,
                    );
                  },
                ),
              )),
            ],
          );
        }
        if (state is SuggestedConnectsSuccessState) {
          var connectionList = state.connections;

          return Container(
            padding: const EdgeInsets.all(18),
            child: RefreshIndicator(
              onRefresh: () async {
                _connectsBloc.add(GetSuggestedConnectsEvent());
                // return Future.delayed(const Duration(milliseconds: 1));
              },
              child: Column(
                children: [
                  connectionList.isEmpty
                      ? Expanded(
                          child: Center(
                              child: AppPromptWidget(
                          onTap: () {
                            _connectsBloc.add(const GetConnectsEvent());
                          },
                          canTryAgain: true,
                          isSvgResource: true,
                          imagePath: "assets/svgs/request.svg",
                          title: "No suggestions yet.",
                          message:
                              "Invite your contacts or search for connecions to start moving!",
                        )))
                      : Expanded(
                          child: ListView.builder(

                              shrinkWrap: true,
                              itemCount: connectionList.length,
                              itemBuilder: (context, index) =>
                                  SearchResultItem(
                                    result: connectionList[index],
                                  )))
                ],
              ),
            ),
          );
        }
        if (state is ConnectsFailureState) {
          return AppPromptWidget(
            // title: "Something went wrong",
            isSvgResource: true,
            message: state.error,
            onTap: () {
              _connectsBloc.add(GetSuggestedConnectsEvent());
            },
          );
        }
        // return const SizedBox.shrink();
        return const Text("Nothing here oo");
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
