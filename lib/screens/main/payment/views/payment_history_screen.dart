import 'package:creative_movers/blocs/payment/payment_bloc.dart';
import 'package:creative_movers/data/remote/model/payment_history_data.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/main/payment/widgets/payment_history_item.dart';
import 'package:creative_movers/screens/main/payment/widgets/payment_history_widget.dart';
import 'package:creative_movers/screens/widget/error_widget.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:creative_movers/helpers/extension.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({Key? key}) : super(key: key);

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  @override
  void initState() {
    super.initState();
    injector.get<PaymentBloc>().add(const GetPaymentHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.black),
        title: const Text(
          'Payment History',
          style: TextStyle(
            // fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list))
        ],
      ),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        bloc: injector.get<PaymentBloc>(),
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is PaymentHistoryLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is PaymentHistoryLoadErrorState) {
            return AppPromptWidget(
              isSvgResource: true,
              message: state.error,
              onTap: () => injector
                  .get<PaymentBloc>()
                  .add(const GetPaymentHistoryEvent()),
            );
          }
          if (state is PaymentHistoryLoadedState) {
            return PaymentHostoryWidget(state.data);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

