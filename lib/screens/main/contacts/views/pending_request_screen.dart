import 'package:creative_movers/blocs/connects/conects_bloc.dart';
import 'package:creative_movers/screens/main/contacts/widgets/connects_shimer.dart';
import 'package:creative_movers/screens/main/contacts/widgets/request_item.dart';
import 'package:creative_movers/screens/widget/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PendingRequestScreen extends StatefulWidget {
  const PendingRequestScreen({Key? key}) : super(key: key);

  @override
  _PendingRequestScreenState createState() => _PendingRequestScreenState();
}

class _PendingRequestScreenState extends State<PendingRequestScreen>
    with AutomaticKeepAliveClientMixin {
  final ConnectsBloc _connectsBloc = ConnectsBloc();

  @override
  void initState() {
    super.initState();
    _connectsBloc.add(GetPendingRequestEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: RefreshIndicator(
        onRefresh: (() async {
          // await Future.delayed(Duration(milliseconds: 1));
          _connectsBloc.add(GetPendingRequestEvent());
        }),
        child: Column(
          children: [
            BlocBuilder<ConnectsBloc, ConnectsState>(
              bloc: _connectsBloc,
              builder: (context, state) {
                if (state is PendingRequestLoadingState) {
                  return Expanded(
                      child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: 5,
                    itemBuilder: (context, index) => const ConnectsShimer(),
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 14,
                      );
                    },
                  ));
                } else if (state is PendingRequestSuccesState) {
                  return state.getConnectsResponse.connections.connectionList
                          .isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: state.getConnectsResponse.connections
                                .connectionList.length,
                            itemBuilder: (context, index) => RequestItem(
                              connection: state.getConnectsResponse.connections
                                  .connectionList[index],
                            ),
                          ),
                        )
                      : Expanded(
                          child: Center(
                              child: AppPromptWidget(
                          onTap: () {
                            _connectsBloc.add(GetPendingRequestEvent());
                          },
                          canTryAgain: true,
                          isSvgResource: true,
                          imagePath: "assets/svgs/request.svg",
                          title: "You have no pending requests.",
                          message: "Invite your contacts to start moving!",
                        )));
                } else if (state is PendingRequestFailureState) {
                  return Expanded(
                      child: AppPromptWidget(
                    onTap: () {
                      _connectsBloc.add(GetPendingRequestEvent());
                    },
                    isSvgResource: true,
                    message: state.error,
                  ));
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
