import 'package:creative_movers/blocs/connects/conects_bloc.dart';
import 'package:creative_movers/screens/main/buisness_page/views/invite_contact_screen.dart';
import 'package:creative_movers/screens/main/contacts/views/contact_screen.dart';
import 'package:creative_movers/screens/main/contacts/widgets/add_contacts_widget.dart';
import 'package:creative_movers/screens/main/contacts/widgets/request_item.dart';
import 'package:creative_movers/screens/widget/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PendingRequestScreen extends StatefulWidget {
  const PendingRequestScreen({Key? key}) : super(key: key);

  @override
  _PendingRequestScreenState createState() => _PendingRequestScreenState();
}

class _PendingRequestScreenState extends State<PendingRequestScreen> {
  ConnectsBloc _connectsBloc = ConnectsBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _connectsBloc.add(GetPendingRequestEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          BlocBuilder<ConnectsBloc, ConnectsState>(
            bloc: _connectsBloc,
            builder: (context, state) {
              if (state is PendingRequestLoadingState) {
                return const Expanded(
                    child: Center(child: CircularProgressIndicator()));
              } else if (state is PendingRequestSuccesState) {
                return state.getConnectsResponse.connections.connectionList
                        .isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: state.getConnectsResponse.connections
                              .connectionList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => RequestItem(
                            connection: state.getConnectsResponse.connections
                                .connectionList[index],
                          ),
                        ),
                      )
                    : const Expanded(
                        child: Center(
                            child: Text('You have no Pending Requests ')));
              } else if (state is PendingRequestFailureState) {
                return Expanded(
                    child: AppErrorWidget(
                  onTap: () {
                    _connectsBloc.add(GetPendingRequestEvent());
                  },
                  message: state.error,
                ));
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}
