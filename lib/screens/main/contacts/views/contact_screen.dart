import 'package:creative_movers/blocs/auth/auth_bloc.dart';
import 'package:creative_movers/blocs/connects/conects_bloc.dart';
import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/main/contacts/views/movers_tab.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  ConnectsBloc _connectsBloc = ConnectsBloc();

  int selectedIndex = 0;
  String userType = 'connects';
  List<Widget> pages = [
    ConnectsTab(data: []),
   Container(),
    Container()
  ];
  // @override
  // void initState() {
  //   _connectsBloc.add(GetConnectsEvent());
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
          length: 3,
          child: Column(
            children: [

              Container(
                margin: EdgeInsets.only(top: 20,left: 16,right: 16),
                height: 50,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                          userType = 'connects';
                        });
                      },
                      child: Chip(
                          padding: EdgeInsets.all(7),
                          avatar: SvgPicture.asset(
                            AppIcons.svgPeople,
                            color: userType == 'connects'
                                ? Colors.white
                                : AppColors.primaryColor,
                          ),
                          backgroundColor: userType == 'connects'
                              ? AppColors.primaryColor
                              : AppColors.lightBlue,
                          label: Text(
                            'Connects',
                            style: TextStyle(
                                fontSize: 13,
                                color: userType == 'connects'
                                    ? Colors.white
                                    : AppColors.textColor),
                          )),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = 1;
                          userType = 'requests';
                        });
                      },
                      child: Chip(
                          padding: EdgeInsets.all(7),
                          avatar: SvgPicture.asset(
                            AppIcons.svgPeople,
                            color: userType == 'requests'
                                ? Colors.white
                                : AppColors.primaryColor,
                          ),
                          backgroundColor: userType == 'requests'
                              ? AppColors.primaryColor
                              : AppColors.lightBlue,
                          label: Text(
                            'Requests',
                            style: TextStyle(
                                fontSize: 13,
                                color: userType == 'requests'
                                    ? Colors.white
                                    : AppColors.textColor),
                          )),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          userType = 'suggestions';
                          selectedIndex = 2 ;
                        });
                      },
                      child: Chip(
                          avatar: Icon(
                            Icons.notifications_rounded,
                            color: userType == 'suggestions'
                                ? Colors.white
                                : AppColors.primaryColor,
                            size: 20,
                          ),
                          backgroundColor: userType == 'suggestions'
                              ? AppColors.primaryColor
                              : AppColors.lightBlue,
                          label: Text(
                            'Suggestions',
                            style: TextStyle(
                                fontSize: 13,
                                color: userType == 'suggestions'
                                    ? Colors.white
                                    : AppColors.textColor),
                          )),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: pages.length,
                  itemBuilder: (context, index) => pages[selectedIndex],),
              ),
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










//
// BlocBuilder<ConnectsBloc, ConnectsState>(
// bloc: _connectsBloc,
// builder: (context, state) {
// if (state is ConnectsLoadingState) {
// return const Expanded(
// child: Center(
// child: CircularProgressIndicator(),
// ));
// }
// else if (state is ConnectsSuccesState) {
// return Expanded(
// child: TabBarView(children: [
// ConnectsTab(
// data: state.getConnectsResponse.connections.data
// ),
// ConnectsTab(
// data: state.getConnectsResponse.connections.data.where((element) => element.role=='creative').toList()
//
// ),
// ConnectsTab(
// data: state.getConnectsResponse.connections.data.where((element) => element.role=='mover').toList()
//
//
// )
// ]));
// }
// else if (state is ConnectsFailureState) {
// return Expanded(
// child: ErrorScreen(
// message: state.error,
// bloc: _connectsBloc,
// ));
// }
// return  Container();
// },
// )

