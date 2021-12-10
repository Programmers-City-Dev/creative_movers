import 'package:creative_movers/screens/auth/widgets/payment_form.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.primaryColor,
        child: Stack(
          children:  [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25),
                alignment: Alignment.bottomLeft,
                height: MediaQuery.of(context).size.height*0.2,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [


                  Text('Welcome Destiny',textAlign:TextAlign.left,style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),),
                  Text('Just one more step before you start exploring',textAlign:TextAlign.left,style: TextStyle(color: Colors.white),),
                    SizedBox(height: 16,)
                ],),),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: PaymentForm(),
            )
          ],
        ),
      ),
    );
  }
}
