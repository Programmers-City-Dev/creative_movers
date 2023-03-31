
import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:creative_movers/screens/auth/widgets/payment_form.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key, this.isFirstTime = false}) : super(key: key);
  final bool isFirstTime;
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.primaryColor,
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            alignment: Alignment.bottomLeft,
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.isFirstTime
                    ? const SizedBox.shrink()
                    : Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () =>
                          Navigator.of(context).pop(),
                      icon: const Icon(Icons.close,
                          size: 32, color: Colors.white)),
                ),
                FutureBuilder<String?>(
                    future:
                    StorageHelper.getString(StorageKeys.firstname),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          'Welcome ${snapshot.data}',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppColors.white),
                        );
                      }
                      return Container();
                    }),
                Text(
                  widget.isFirstTime
                      ? 'Just one more step before you start exploring'
                      : "Let's get your payment done to continue enjoying our services",
                  textAlign: TextAlign.left,
                  style: const TextStyle(color: AppColors.white),
                ),
                const SizedBox(
                  height: 16,
                )
              ],
            ),
          ),
          Expanded(
            child: PaymentForm(
              isFirstTime: widget.isFirstTime,
            ),
          ),
        ],) ,
      ),
    );
  }
}
// Stack(
//           children: [
//             Align(
//               alignment: Alignment.topCenter,
//               child: Stack(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 25),
//                     alignment: Alignment.bottomLeft,
//                     height: MediaQuery.of(context).size.height * 0.2,
//                     width: MediaQuery.of(context).size.width,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         widget.isFirstTime
//                             ? const SizedBox.shrink()
//                             : Align(
//                                 alignment: Alignment.topRight,
//                                 child: IconButton(
//                                     onPressed: () =>
//                                         Navigator.of(context).pop(),
//                                     icon: const Icon(Icons.close,
//                                         size: 32, color: Colors.white)),
//                               ),
//                         FutureBuilder<String?>(
//                             future:
//                                 StorageHelper.getString(StorageKeys.firstname),
//                             builder: (context, snapshot) {
//                               if (snapshot.hasData) {
//                                 return Text(
//                                   'Welcome ${snapshot.data}',
//                                   textAlign: TextAlign.left,
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20,
//                                       color: AppColors.white),
//                                 );
//                               }
//                               return Container();
//                             }),
//                         Text(
//                           widget.isFirstTime
//                               ? 'Just one more step before you start exploring'
//                               : "Let's get your payment done to continue enjoying our services",
//                           textAlign: TextAlign.left,
//                           style: const TextStyle(color: AppColors.white),
//                         ),
//                         const SizedBox(
//                           height: 16,
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: PaymentForm(
//                 isFirstTime: widget.isFirstTime,
//               ),
//             )
//           ],
//         )