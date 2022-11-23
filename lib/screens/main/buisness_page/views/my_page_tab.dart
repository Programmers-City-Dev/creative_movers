import 'package:creative_movers/blocs/buisness/buisness_bloc.dart';
import 'package:creative_movers/screens/widget/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'buisness_profile.dart';

class MyPageTab extends StatefulWidget {
  const MyPageTab({Key? key}) : super(key: key);

  @override
  _MyPageTabState createState() => _MyPageTabState();
}

BuisnessBloc _buisnessBloc = BuisnessBloc();

class _MyPageTabState extends State<MyPageTab> {
  @override
  void initState() {
    super.initState();

    _buisnessBloc.add(BuisnessProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<BuisnessBloc, BuisnessState>(
        bloc: _buisnessBloc,
        builder: (context, state) {
          if (state is BuisnessLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is BuisnessSuccesState) {
            //---- A check was initially made here (checking if page is empty ) check buttom of code incase!!

            return RefreshIndicator(
                onRefresh: () async {
                  _buisnessBloc.add(BuisnessProfileEvent());
                  // _buisnessBloc.add(PageSuggestionsEvent());
                },
                child: BuisnessProfileScreen(
                  profile: state.buisnessProfile,
                  onCreatePage: () {
                    _buisnessBloc.add(BuisnessProfileEvent());
                  },
                ));
          } else if (state is BuisnessFailureState) {
            return AppPromptWidget(
              // title: "Something went wrong",
              isSvgResource: true,
              message: state.error,
              onTap: () {
                _buisnessBloc.add(BuisnessProfileEvent());
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

//---------------- Deleted Pages Check -----------

// if (state.buisnessProfile.profile.pages.isNotEmpty) {
// return Expanded(
// child: BuisnessProfileScreen(profile: state.buisnessProfile));
// } else {
// return Center(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Column(
// mainAxisSize: MainAxisSize.min,
// children: [
// SvgPicture.asset(
// 'assets/svgs/request.svg',
// height: 100,
// ),
// const SizedBox(
// height: 16,
// ),
// const Text(
// 'You have no pages yet..',
// style: TextStyle(
// fontSize: 16, fontWeight: FontWeight.w600),
// ),
// const SizedBox(
// height: 16,
// ),
// Padding(
// padding: const EdgeInsets.symmetric(horizontal: 20),
// child: CustomButton(
// child: const Text('CREATE A BUSINESS PAGE'),
// onTap: () {
// Navigator.of(context).push(MaterialPageRoute(
// builder: (context) => const CreatePageOnboarding(),
// ));
// },
// ),
// )
// ],
// ),
// ),
// );
// }
