import 'package:creative_movers/screens/auth/views/payment_screen.dart';
import 'package:creative_movers/screens/auth/widgets/contact_item.dart';
import 'package:creative_movers/screens/widget/search_field.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({Key? key}) : super(key: key);

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  bool isAdded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        'My Connection',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: SearchField(
                        hint: 'Search Contacts',
                      )),
                    ],
                  ),
                  const Text(
                    'We found some Creatives and Movwers you might like to connect with',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: AppColors.lightGrey,
                                shape: const StadiumBorder(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16)),
                            onPressed: () {},
                            child: Row(
                              children: const [
                                Text(
                                  'Skip',
                                  style: TextStyle(color: AppColors.textColor),
                                ),
                                Icon(
                                  Icons.skip_next_outlined,
                                  color: AppColors.textColor,
                                ),
                              ],
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                shape: const StadiumBorder(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16)),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const PaymentScreen(),
                              ));
                            },
                            child: const Text(
                              'Add',
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                thickness: 2,
              ),
            ),
            Expanded(
                child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) => ContactItem(
                onTap: () {
                  setState(() {
                    isAdded = !isAdded;
                  });
                },
                isAdded: isAdded,
              ),
            ))
          ],
        ),
      ),
    );
  }
}
