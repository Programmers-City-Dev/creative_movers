import 'package:creative_movers/screens/auth/widgets/details_saved_succes_dialog.dart';
import 'package:creative_movers/screens/auth/widgets/payment_succes_dialog.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:creative_movers/theme/style/app_styles.dart';
import 'package:flutter/material.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({Key? key}) : super(key: key);

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {

  bool saveDetails = true;
  List<String> options = [
    'Start Free Trial For 9 days',
    'Pay \$7.00 now (Monthly Reoccuring Fee)'
  ];
  String selectedPaymentMode = 'free';

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery
            .of(context)
            .size
            .height * 0.8,
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const Text(
              'You will be charged \$7.00 to enjoy all the services as well as all benefits of creatives  or movers  ',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(
              height: 18,
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Radio(value: selectedPaymentMode,
                              groupValue: 'free',
                              onChanged: (val) {
                                setState(() {
                                  selectedPaymentMode = 'free';
                                });
                              }),
                          Expanded(child: Text(options[0]))
                        ],
                      ),
                      Row(
                        children: [
                          Radio(value: selectedPaymentMode,
                              groupValue: 'paid',
                              onChanged: (val) {
                                setState(() {
                                  selectedPaymentMode = 'paid';
                                });
                              }),
                          Expanded(child: Text(options[1]))
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const Text(
                        'Card Number',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          decoration:  AppStyles.labeledFieldDecoration()

                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Card Number',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                ),
                                TextFormField(
                                    decoration:  AppStyles.labeledFieldDecoration()
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'CVV',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                ),
                                TextFormField(
                                    decoration:  AppStyles.labeledFieldDecoration()
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const Text(
                        'Card Holders Name',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          decoration:  AppStyles.labeledFieldDecoration()
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9)),
                              value: saveDetails,
                              onChanged: (checked) {
                                setState(() {
                                  saveDetails = checked!;
                                });
                              }),
                          const Text('Save Card Details')
                        ],
                      )
                    ],
                  ),
                )),
            CustomButton(
              child: Text(selectedPaymentMode == 'free'
                  ? 'Save and Start Trial'
                  : 'Make Payment'),
              onTap: () async {
                await Future.delayed(Duration(seconds: 1));
                selectedPaymentMode == 'paid'
                    ?
                showDialog(
                  // barrierDismissible: false,
                    context: context,
                    builder: (context) => const PaymentSuccesDialog())
                    : showDialog(context: context, builder: (context) => const DetailsSavedDialog(),);
              },
            )
          ],
        ),
      ),
    );
  }
}
