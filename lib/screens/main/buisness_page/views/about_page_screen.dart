import 'package:creative_movers/data/remote/model/buisness_profile_response.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AboutPageScreen extends StatefulWidget {
  const AboutPageScreen({Key? key, required this.page}) : super(key: key);
  final BusinessPage page;


  @override
  _AboutPageScreenState createState() => _AboutPageScreenState();
}

class _AboutPageScreenState extends State<AboutPageScreen> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            decoration:  BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        widget.page.photoPath!= null?

                        widget.page.photoPath! :'https://businessexperttips.com/wp-content/uploads/2022/01/3.jpg'

                    ))),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            AppColors.black.withOpacity(1),
                            AppColors.black.withOpacity(0.5),
                            AppColors.black.withOpacity(0.3)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter)),
                ),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           Text(
                           widget.page.name,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          // Row(
                          //   children: [
                          //     ImageStack.providers(
                          //       imageBorderWidth: 1,
                          //       providers: const [
                          //         NetworkImage(
                          //             'https://encrypted-tbn0.gstatic.com/imag'
                          //                 'es?q=tbn:ANd9GcSEEpS06Ncz7d5uaqQvvcQeB'
                          //                 'IsMSaTdFerTaA&usqp=CAU'),
                          //         NetworkImage(
                          //             'https://encrypted-tbn0.gstatic.com/imag'
                          //                 'es?q=tbn:ANd9GcSEEpS06Ncz7d5uaqQvvcQeB'
                          //                 'IsMSaTdFerTaA&usqp=CAU'),
                          //         NetworkImage(
                          //           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9'
                          //               'GcTvSxYr3ogP7Xpf9ivCAiMA8yYKb4RC5XIO-8OiqiAwci_hZurI_'
                          //               'LZKNzyR9E9kzjH55-w&usqp=CAU',
                          //         ),
                          //         NetworkImage(
                          //           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9'
                          //               'GcTvSxYr3ogP7Xpf9ivCAiMA8yYKb4RC5XIO-8OiqiAwci_hZurI_'
                          //               'LZKNzyR9E9kzjH55-w&usqp=CAU',
                          //         )
                          //       ],
                          //       totalCount: 5,
                          //       imageCount: 5,
                          //     ),
                          //     SizedBox(
                          //       width: 10,
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                            height: 5,
                          ),

                        ],
                      ),
                    ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                 Text(
                 widget.page.description,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16,),

                const Text(
                'Business Category',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 5,
                children: List<Widget>.generate(
                    widget.page.category.length,
                        (index) =>  Chip(
                      label: Text(widget.page.category[index]),
                    )),
              ),
                const SizedBox(height: 16,),
                const Text(
                  'Stage of investment',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5,),
                Text(
                  widget.page.stage,
                  style: const TextStyle(color: Colors.grey),

                ),
                const SizedBox(height: 16,),
                const Text(
                  'Website',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5,),
                 Text(
                  widget.page.website.toString(),
                  style: TextStyle(color: Colors.grey),

                ),
                const SizedBox(height: 16,),
                const Text(
                  'Contact Information',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5,),
                 Text(
                  widget.page.contact.toString(),
                  style: TextStyle(color: Colors.grey),

                ),
            ],),
          )

      ],),
        ),),
    ));
  }
}
