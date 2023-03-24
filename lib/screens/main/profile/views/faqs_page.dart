import 'package:creative_movers/blocs/profile/profile_bloc.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/injector.dart';
import '../widgets/faq_item.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final ProfileBloc _profileBloc = ProfileBloc(injector.get());

  @override
  void initState() {
    _profileBloc.add(GetFaqsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Faqs',
          style: TextStyle(color: AppColors.textColor),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.textColor),
        titleSpacing: 0,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: _profileBloc,
        builder: (context, state) {
          if (state is GetFaqsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is GetFaqsSuccessState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(children: [
                ListView.builder(
                  primary: false,
                  itemCount: state.faqsResponse.faqs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => FaqItem(
                    index: index + 1,
                    faq: state.faqsResponse.faqs[index],
                  ),
                )
              ]),
            );
          } else if (state is GetFaqsFailureState) {
            return Text(state.error);
          } else {
            return const Text('Error');
          }
        },
      ),
    );
  }
}
