import 'package:creative_movers/data/remote/model/payment_history_data.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/helpers/extension.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PaymentHistoryItem extends StatelessWidget {
  final PaymentHistory historyData;

  const PaymentHistoryItem({Key? key, required this.historyData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        _showMorePaymentHistoryData(context, historyData);
      },
      leading: const Icon(Icons.payment_outlined),
      title: Text(
        getPaymentFor(historyData.paymentFor),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(AppUtils.getDateAndTime(historyData.createdAt)),
      trailing: Column(
        children: [
          Text(
            getPaymentFor('\$${historyData.amount}'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                color: historyData.status == "completed"
                    ? Colors.green
                    : historyData.status == "pending"
                        ? Colors.orange
                        : Colors.red,
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              historyData.status.toFirstUppercase,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String getPaymentFor(String paymentFor) {
    List<String> data = paymentFor.split("_");
    return data.map((e) => e.toFirstUppercase).join(" ");
  }

  void _showMorePaymentHistoryData(
      BuildContext context, PaymentHistory historyData) {
    showMaterialModalBottomSheet(
        context: context,
        expand: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        builder: (_) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("More Details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22)),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ListTile(
                  title: const Text("Payment ID",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                  subtitle: Text(historyData.orderId),
                  trailing: GestureDetector(
                      onTap: (() {}), child: const Icon(Icons.copy)),
                ),
                ListTile(
                  title: const Text("Purpose",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                  subtitle: Text(getPaymentFor(historyData.paymentFor),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  trailing: Text('\$${historyData.amount}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 32)),
                ),
                ListTile(
                  title: const Text("Payment Date",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
                  subtitle:
                      Text(AppUtils.getDateAndTime(historyData.createdAt)),
                  trailing: Column(
                    children: [
                      Text(
                        getPaymentFor('Status'),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            color: historyData.status == "completed"
                                ? Colors.green
                                : historyData.status == "pending"
                                    ? Colors.orange
                                    : Colors.red,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          historyData.status.toFirstUppercase,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ));
  }
}
