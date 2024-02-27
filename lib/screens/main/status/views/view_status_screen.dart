import 'dart:developer';

import 'package:creative_movers/data/remote/model/view_status_response.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class ViewStatusScreen extends StatefulWidget {
  final List<Status>? alllStatus;
  final List<StatusElement> status;
  final int currentStatus;

  const ViewStatusScreen(
      {Key? key,
      required this.status,
      this.alllStatus,
      required this.currentStatus})
      : super(key: key);

  @override
  _ViewStatusScreenState createState() => _ViewStatusScreenState();
}

class _ViewStatusScreenState extends State<ViewStatusScreen> {
  final storyController = StoryController();
  var pageController;
  int currentStatus = 0;
  List<List<StoryItem>> stories = [];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.currentStatus);
    currentStatus = widget.currentStatus;

    //Looping through all the status for each user
    for (Status eachStatus in widget.alllStatus!) {
      //List of converted status element for a user
      List<StoryItem> storyItems = [];

      //Loops through each users status element to convert it to story item
      //and adds them to the List of converted status element for a user declared up ^^^
      for (StatusElement status in eachStatus.status) {
        storyItems.add(
          status.file == null
              ? StoryItem.text(
                  title: status.text!,
                  textStyle:
                      TextStyle(fontFamily: status.fontName, fontSize: 40),
                  backgroundColor: Color(int.parse(status.bgColor!, radix: 16)),
                )
              : status.mediaType == 'image'
                  ? StoryItem.pageImage(
                      url: status.file!,
                      caption: Text(status.text.toString()),
                      controller: storyController,
                    )
                  : StoryItem.pageVideo(status.file!,
                      caption: Text(status.text.toString()), controller: storyController),
        );

        //Once it converts all statusElement for each user it
        // Adds all  converted status elements to the list of all status
        if (storyItems.length == eachStatus.status.length) {
          stories.add(storyItems);
          log('STORIES${stories.length.toString()}');
        }
      }
    }
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (context, index) => StoryView(
        storyItems: stories[index]
        // widget.status.file == null?
        // StoryItem.text(
        //   title: widget.status.text,
        //   backgroundColor: Colors.blue,
        // ): widget.status.mediaType == 'image'?  StoryItem.pageImage(
        //   url:
        //   widget.status.file!,
        //   caption: "Still sampling",
        //   controller: storyController,
        // ): StoryItem.pageVideo(
        //        widget.status.file! ,
        //     caption: "Working with gifs",
        //     controller: storyController),

        // StoryItem.text(
        //   title: "Nice!\n\nTap to continue.",
        //   backgroundColor: Colors.red,
        //   textStyle: const TextStyle(
        //     fontFamily: 'Dancing',
        //     fontSize: 40,
        //   ),
        // ),
        //
        //
        // StoryItem.pageImage(
        //   url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
        //   caption: "Hello, from the other side",
        //   controller: storyController,
        // ),
        // StoryItem.pageImage(
        //   url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
        //   caption: "Hello, from the other side2",
        //   controller: storyController,
        // ),
        ,
        onStoryShow: (s,i) {
          print("Showing a story");
        },
        onComplete: () {
          log('INDEX ${index.toString()}');
          if (index + 1 != stories.length) {
            pageController.animateToPage(index + 1,
                duration: const Duration(seconds: 1), curve: Curves.ease);
          } else {
            Navigator.pop(context);
          }
          print("Completed a cycle");
          // Navigator.pop(context);
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
      itemCount: stories.length,
      controller: pageController,
      onPageChanged: (index) {
        setState(() {
          currentStatus = index;
        });
      },
    );
  }
}
