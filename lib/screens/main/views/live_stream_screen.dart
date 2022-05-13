import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/main/widgets/stream_comment_item.dart';
import 'package:creative_movers/screens/widget/search_field.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({Key? key}) : super(key: key);

  @override
  _LiveStreamScreenState createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: AppColors.smokeWhite,
                  image: DecorationImage(
                      image: AssetImage(AppIcons.imgSlide2),
                      fit: BoxFit.cover)),
            ),
            Container(
              decoration: BoxDecoration(color: AppColors.black.withOpacity(0.1)),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    height: 50,
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'LIVE',
                            style: TextStyle(color: AppColors.smokeWhite),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor: AppColors.red),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Row(
                            children: const [
                              Icon(
                                Icons.visibility_rounded,
                                size: 25,
                                color: AppColors.smokeWhite,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '23,4422',
                                style: TextStyle(color: AppColors.smokeWhite),
                              ),
                            ],
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor:
                                  AppColors.commentBg.withOpacity(0.6)),
                        )
                      ],
                    ),
                  ),
                  Expanded(child: const SizedBox.expand()),
                  Container(
                    height: 350,
                    decoration: BoxDecoration(
                        color: AppColors.commentBg.withOpacity(0.1)),
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(children: [
                            ListView.builder(
                              itemBuilder: (context, index) =>
                                  const StreamCommentItem(),
                              itemCount: 10,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 10,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
                                decoration: BoxDecoration(


                                border: Border.symmetric(vertical: BorderSide(color: Colors.transparent.withOpacity(0.8))) ,
                                  boxShadow: [
                                    BoxShadow(color:  AppColors.black.withOpacity(0.08),blurRadius: 12,spreadRadius: 12)
                                  ],
                                  gradient:  LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent.withOpacity(0.1),
                                        AppColors.black.withOpacity(0.1),
                                        AppColors.black.withOpacity(0.1)
                                      ]),
                                ),

                              ),
                            ),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 16.0, left: 16.0, bottom: 8.0, top: 5),
                          child: Row(
                            children: [
                              Expanded(
                                  child: TextField(
                                onChanged: (val) {},

                                // controller: _controller,
                                decoration: InputDecoration(
                                    hintText: 'Comment',
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: const BorderSide(
                                            width: 2,
                                            color: AppColors.smokeWhite)),
                                    hintStyle: TextStyle(
                                        color: AppColors.smokeWhite
                                            .withOpacity(0.7)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: AppColors.smokeWhite
                                                .withOpacity(0.7))),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(
                                          color: AppColors.smokeWhite
                                              .withOpacity(0.7),
                                          width: 2,
                                        ))),
                                minLines: 1,
                                maxLines: 5,
                                style: TextStyle(
                                    color:
                                        AppColors.smokeWhite.withOpacity(0.7)),
                              )),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.thumb_up_outlined,
                                      color:
                                          AppColors.smokeWhite.withOpacity(0.7),
                                    ),
                                    Text(
                                      '345',
                                      style: TextStyle(
                                          color: AppColors.smokeWhite
                                              .withOpacity(0.7)),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
