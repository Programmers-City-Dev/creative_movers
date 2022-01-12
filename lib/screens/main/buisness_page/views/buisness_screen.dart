import 'dart:ui';

import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BuisnessScreen extends StatefulWidget {
  const BuisnessScreen({Key? key}) : super(key: key);

  @override
  _BuisnessScreenState createState() => _BuisnessScreenState();
}

class _BuisnessScreenState extends State<BuisnessScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              height: 250,
              decoration: const BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        'https://i.pinimg.com/736x/d2/b9/67/d2b967b386e178ee3a148d3a7741b4c0.jpg',
                      ))),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.stacked_bar_chart_rounded,
                      color: AppColors.smokeWhite,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Buisness Profile',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Amanda Berks',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 10,
                        width: 2,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      const Text(
                        'Creative ',
                        style: TextStyle(
                            color: AppColors.primaryColor, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    ' I am  senior developer focused on mobile apps and website '
                    'development. i am not only competent in delivering the effective deliverable ... ',
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Buisness Category',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 5,
                    children: List<Widget>.generate(
                        6,
                        (index) => const Chip(
                              label: Text('Information  '),
                            )),
                  ),
                  const Text(
                    'Buisness Pages',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration:  BoxDecoration(
                            borderRadius:BorderRadius.circular(10),
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                  image: NetworkImage(

                            'https://i.pinimg.com/736x/d2/b9/67/d2b967b386e178ee3a148d3a7741b4c0.jpg',
                          ))),
                        ),
                        SizedBox(width: 10,),
                        Text('JAVIE NETWORK',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),)
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    color: Colors.grey.shade200,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          child: const Icon(
                            Icons.add_circle_outline_rounded,
                            color: Colors.white,
                          ),
                          height: 40,
                          width: 40,
                          decoration:  BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius:BorderRadius.circular(10),
                            
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text('CREATE A BUISNESS PAGE',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,fontSize: 12),)
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
