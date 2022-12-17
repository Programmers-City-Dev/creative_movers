import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/main/buisness_page/views/invite_contact_screen.dart';
import 'package:flutter/material.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({Key? key}) : super(key: key);

  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  List<String> placeholders = [
    AppIcons.icPlaceHolder1,
    AppIcons.icPlaceHolder2,
    AppIcons.icPlaceHolder3,
    AppIcons.icPlaceHolder4
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: placeholders.length,
                  itemBuilder: (context, index) => CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(placeholders[index]),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Invite new visitor to like your page to attract '
                  'more movers and grow your audience',
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const InviteContactScreen(),
                      ));
                    },
                    child: const Text(
                      'INVITE CONTACTS',
                      style: TextStyle(fontSize: 16),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
