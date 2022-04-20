import 'package:creative_movers/data/remote/model/payment_history_data.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/screens/main/payment/widgets/payment_history_item.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class PaymentHostoryWidget extends StatelessWidget {
  final PaymentHistoryResponse data;

  const PaymentHostoryWidget(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PaymentHistory> history = data.user!.paymentHistory;
    return GroupedListView<PaymentHistory, int>(
      shrinkWrap: true,
      elements: history,
      groupBy: (history) => DateTime(history.createdAt.year,
              history.createdAt.month, history.createdAt.day)
          .millisecondsSinceEpoch,
      groupSeparatorBuilder: (groupByValue) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppUtils.getGroupLabel(groupByValue),
            style: const TextStyle(color: AppColors.textColor, fontSize: 13),
          ),
        ),
      ),
      itemBuilder: (context, history) => PaymentHistoryItem(
        historyData: history,
      ),
      itemComparator: (item1, item2) => item1.createdAt.millisecondsSinceEpoch
          .compareTo(item2.createdAt.millisecondsSinceEpoch), // optional
      // useStickyGroupSeparators: true, // optional
      floatingHeader: false, // optional
      order: GroupedListOrder.DESC, // optional
    );
  }
}
