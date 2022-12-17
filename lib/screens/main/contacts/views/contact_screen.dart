import 'package:creative_movers/blocs/connects/conects_bloc.dart';
import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/main/contacts/views/movers_tab.dart';
import 'package:creative_movers/screens/main/contacts/views/pending_request_screen.dart';
import 'package:creative_movers/screens/main/contacts/views/suggested_users_tab.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>
    with SingleTickerProviderStateMixin {
  final ConnectsBloc _connectsBloc = ConnectsBloc();

  int selectedIndex = 0;
  String userType = 'connects';
  List<Widget> pages = const [
    ConnectsTab(),
    PendingRequestScreen(),
    SuggestedUsersTab()
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => setState(() {
                    selectedIndex = 0;
                    _tabController.animateTo(selectedIndex);
                  }),
                  child: Chip(
                      padding: const EdgeInsets.all(7),
                      avatar: SvgPicture.asset(
                        AppIcons.svgPeople,
                        color: selectedIndex == 0
                            ? AppColors.white
                            : AppColors.primaryColor,
                      ),
                      backgroundColor: selectedIndex == 0
                          ? AppColors.primaryColor
                          : AppColors.lightBlue,
                      label: Text(
                        'Connects',
                        style: TextStyle(
                            fontSize: 13,
                            color: selectedIndex == 0
                                ? AppColors.white
                                : AppColors.textColor),
                      )),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    selectedIndex = 1;
                    _tabController.animateTo(selectedIndex);
                  }),
                  child: Chip(
                      padding: const EdgeInsets.all(7),
                      avatar: SvgPicture.asset(
                        AppIcons.svgPeople,
                        color: selectedIndex == 1
                            ? AppColors.white
                            : AppColors.primaryColor,
                      ),
                      backgroundColor: selectedIndex == 1
                          ? AppColors.primaryColor
                          : AppColors.lightBlue,
                      label: Text(
                        'Requests',
                        style: TextStyle(
                            fontSize: 13,
                            color: selectedIndex == 1
                                ? AppColors.white
                                : AppColors.textColor),
                      )),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    selectedIndex = 2;
                    _tabController.animateTo(selectedIndex);
                  }),
                  child: Chip(
                      avatar: Icon(
                        Icons.notifications_rounded,
                        color: selectedIndex == 2
                            ? AppColors.white
                            : AppColors.primaryColor,
                        size: 20,
                      ),
                      backgroundColor: selectedIndex == 2
                          ? AppColors.primaryColor
                          : AppColors.lightBlue,
                      label: Text(
                        'Suggestions',
                        style: TextStyle(
                            fontSize: 13,
                            color: selectedIndex == 2
                                ? AppColors.white
                                : AppColors.textColor),
                      )),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
              controller: _tabController,
              children: pages,
            ),
          )
        ],
      ),
    );
  }

  void _handleTabSelection() {
    setState(() {
      selectedIndex = _tabController.index;
      // log("INDEX:$selectedIndex");
    });
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
// TabBar(
// padding: EdgeInsets.symmetric(horizontal: 25),
// isScrollable: false,
// indicatorPadding: EdgeInsets.all(7),
// indicator: BoxDecoration(
// color: AppColors.white,
// shape: BoxShape.rectangle,
// borderRadius: BorderRadius.circular(16)),
// labelColor: AppColors.primaryColor,
// tabs: const [
// Tab(
// text: 'All',
// ),
// Tab(
// text: 'Creatives',
// ),
// Tab(
// text: 'Movers',
// ),
// ]),
// )

// Container(
//                 margin: EdgeInsets.only(top: 20, left: 16, right: 16),
//                 height: 50,
//                 child: ListView(
//                   physics: BouncingScrollPhysics(),
//                   scrollDirection: Axis.horizontal,
//                   shrinkWrap: true,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           selectedIndex = 0;
//                           userType = 'connects';
//                         });
//                       },
//                       child: Chip(
//                           padding: EdgeInsets.all(7),
//                           avatar: SvgPicture.asset(
//                             AppIcons.svgPeople,
//                             color: userType == 'connects'
//                                 ? AppColors.white
//                                 : AppColors.primaryColor,
//                           ),
//                           backgroundColor: userType == 'connects'
//                               ? AppColors.primaryColor
//                               : AppColors.lightBlue,
//                           label: Text(
//                             'Connects',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 color: userType == 'connects'
//                                     ? AppColors.white
//                                     : AppColors.textColor),
//                           )),
//                     ),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           selectedIndex = 1;
//                           userType = 'requests';
//                         });
//                       },
//                       child: Chip(
//                           padding: EdgeInsets.all(7),
//                           avatar: SvgPicture.asset(
//                             AppIcons.svgPeople,
//                             color: userType == 'requests'
//                                 ? AppColors.white
//                                 : AppColors.primaryColor,
//                           ),
//                           backgroundColor: userType == 'requests'
//                               ? AppColors.primaryColor
//                               : AppColors.lightBlue,
//                           label: Text(
//                             'Requests',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 color: userType == 'requests'
//                                     ? AppColors.white
//                                     : AppColors.textColor),
//                           )),
//                     ),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           userType = 'suggestions';
//                           selectedIndex = 2;
//                         });
//                       },
//                       child: Chip(
//                           avatar: Icon(
//                             Icons.notifications_rounded,
//                             color: userType == 'suggestions'
//                                 ? AppColors.white
//                                 : AppColors.primaryColor,
//                             size: 20,
//                           ),
//                           backgroundColor: userType == 'suggestions'
//                               ? AppColors.primaryColor
//                               : AppColors.lightBlue,
//                           label: Text(
//                             'Suggestions',
//                             style: TextStyle(
//                                 fontSize: 13,
//                                 color: userType == 'suggestions'
//                                     ? AppColors.white
//                                     : AppColors.textColor),
//                           )),
//                     ),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                   ],
//                 ),
//               ),
