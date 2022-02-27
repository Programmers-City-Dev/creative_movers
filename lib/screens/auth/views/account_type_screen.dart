import 'package:creative_movers/screens/auth/views/creative_form.dart';
import 'package:creative_movers/screens/auth/views/mover_form.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AccountTypeScreen extends StatefulWidget {
  const AccountTypeScreen({Key? key, required this.categories, }) : super(key: key);
 final List<String> categories;

  @override
  _AccountTypeScreenState createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends State<AccountTypeScreen> {
  String accountType = '';
  bool isEnabled = false;
  List<String> items = ['Creative', 'Mover'];

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        iconTheme: const IconThemeData(color: AppColors.textColor, ),
        toolbarTextStyle: const TextStyle(color: AppColors.textColor,),
        backgroundColor: Colors.white,
        title: const Text(
          'Select Account Type',

          style: TextStyle(color: AppColors.textColor,fontSize: 16),
        ),
      ),
      body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              // DropdownButtonFormField<String>(
              //   decoration: const InputDecoration(
              //       labelText: 'Select User Account Type',
              //       contentPadding: EdgeInsets.all(16),
              //       border: OutlineInputBorder(borderSide: BorderSide())),
              //   hint: const Text('Select Account Type'),
              //   value: null,
              //   onChanged: (value) {
              //     setState(() {
              //       account_type = value!;
              //       isEnabled = true;
              //     });
              //   },
              //   items: items
              //       .map((e) =>
              //           DropdownMenuItem<String>(value: e, child: Text(e)))
              //       .toList(),
              // ),

              ToggleSwitcher(
                onSelected: (index) {
                  pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutQuart);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(),
              Expanded(
                  child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                // scrollDirection: Axis.vertical,
                controller: pageController,
                children:  [ CreativeForm(categories:widget.categories ,),MoverForm(categories: widget.categories,),],
              )),
              // Expanded(
              //     child: account_type == 'Mover'
              //         ? const MoverForm()
              //         : account_type == 'Creative'
              //             ? CreativeForm()
              //             : const Center(
              //                 child: Text('Select Account Type to Continue'),
              //               )),
            ],
          )),
    );
  }
}

class ToggleSwitcher extends StatefulWidget {
  const ToggleSwitcher({Key? key, required this.onSelected}) : super(key: key);

  final Function(int) onSelected;

  @override
  _ToggleSwitcherState createState() => _ToggleSwitcherState();
}

class _ToggleSwitcherState extends State<ToggleSwitcher> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Card(
            elevation: selectedIndex == 0 ? 8 : 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(
                  color: selectedIndex == 0
                      ? AppColors.primaryColor
                      : Colors.white,
                )),
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                  widget.onSelected(selectedIndex);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.check_circle_outline_sharp,
                        color: selectedIndex == 0
                            ? AppColors.primaryColor
                            : Colors.grey,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Creative',
                        style: TextStyle(
                          fontWeight: selectedIndex == 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Card(
            elevation: selectedIndex == 1 ? 8 : 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(
                  color: selectedIndex == 1
                      ? AppColors.primaryColor
                      : Colors.white,
                )),
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                  widget.onSelected(selectedIndex);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.check_circle_outline_sharp,
                        color: selectedIndex == 1
                            ? AppColors.primaryColor
                            : Colors.grey,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Movers',
                        style: TextStyle(
                          fontWeight: selectedIndex == 1
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
