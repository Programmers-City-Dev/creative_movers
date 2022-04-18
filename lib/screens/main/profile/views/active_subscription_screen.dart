import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:flutter/material.dart';

class ActiveSubscriptionScreen extends StatefulWidget {
  const ActiveSubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<ActiveSubscriptionScreen> createState() =>
      _ActiveSubscriptionScreenState();
}

class _ActiveSubscriptionScreenState extends State<ActiveSubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Active Subscription',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            Card(
              child: Column(
                children: [
                  const ListTile(
                    title: Text('Monthly Subscription',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Monthly Subscription'),
                    trailing: Text('\$10.00'),
                  ),
                  const ListTile(
                    title: Text(
                      'Subscription Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Subscription Date'),
                    trailing: Text('Subscription Date'),
                  ),
                  const ListTile(
                    title: Text('Subscription Status',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Subscription Status'),
                    trailing: Text('Subscription Status'),
                  ),
                ],
              ),
            ),
            Spacer(),
            CustomButton(
              child: Text('Cancel Subscription'),
              onTap: () {},
            ),
            const SizedBox(
              height: 16,
            ),
            CustomButton(
              child: Text('Cancel Subscription'),
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
