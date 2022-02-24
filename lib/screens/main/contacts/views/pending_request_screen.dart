import 'package:creative_movers/blocs/connects/conects_bloc.dart';
import 'package:creative_movers/screens/main/buisness_page/views/invite_contact_screen.dart';
import 'package:creative_movers/screens/main/contacts/views/contact_screen.dart';
import 'package:creative_movers/screens/main/contacts/widgets/add_contacts_widget.dart';
import 'package:creative_movers/screens/main/contacts/widgets/connects_shimer.dart';
import 'package:creative_movers/screens/main/contacts/widgets/request_item.dart';
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
              if(state is PendingRequestLoadingState){
                return  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) => ConnectsShimer(),
                      separatorBuilder: (BuildContext context, int index) { return SizedBox(height: 14,); },
                    ));
              }else if(state is PendingRequestSuccesState){


                return state.getConnectsResponse.connections.connectionList.isNotEmpty?
                Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: state.getConnectsResponse.connections.connectionList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>  RequestItem(connection: state.getConnectsResponse.connections.connectionList[index],),
                  ),
                ):Expanded(child: Center(child: Text('You have no Pending Requests ')));


              }else if(state is PendingRequestFailureState){
                return Expanded(child: ErrorScreen( onTap: (){
                _connectsBloc.add(GetPendingRequestEvent());
                },message: state.error,));
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}
