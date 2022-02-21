import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/blocs/connects/conects_bloc.dart';
import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/main/contacts/views/movers_tab.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  ConnectsBloc _connectsBloc = ConnectsBloc();

  @override
  void initState() {
    _connectsBloc.add(GetConnectsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  isScrollable: false,
                  indicatorPadding: EdgeInsets.all(7),
                  indicator: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16)),
                  labelColor: AppColors.primaryColor,
                  tabs: const [
                    Tab(
                      text: 'All',
                    ),
                    Tab(
                      text: 'Creatives',
                    ),
                    Tab(
                      text: 'Movers',
                    ),
                  ]),
              BlocBuilder<ConnectsBloc, ConnectsState>(
                bloc: _connectsBloc,
                builder: (context, state) {
                  if (state is ConnectsLoadingState) {
                    return const Expanded(
                        child: Center(
                      child: CircularProgressIndicator(),
                    ));
                  } else if (state is ConnectsSuccesState) {
                    return Expanded(
                        child: TabBarView(children: [
                      MoversTab(
                        data: state.getConnectsResponse.connections.data


                      ),
                      const MoversTab(
                        data: [],
                      ),
                      const MoversTab(
                        data: [],
                      )
                    ]));
                  } else if (state is ConnectsFailureState) {
                    return Expanded(
                        child: ErrorScreen(
                      message: state.error,
                          bloc: _connectsBloc,
                    ));
                  }
                  return  Container();
                },
              )
            ],
          )),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String? message;
  final ConnectsBloc? bloc;

  ErrorScreen({this.message = 'Ooops an error occured ', this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/pngs/sorry.png',
            height: 150,
          ),
          Text(message!),
          SizedBox(
            height: 10,
          ),
          CustomButton(
            onTap: () {
              bloc?.add(GetConnectsEvent());
            },
            child: const Text('Retry'),
          )
        ],
      )),
    );
  }
}

