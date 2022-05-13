import 'package:creative_movers/data/remote/model/view_status_response.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class ViewStatusScreen extends StatefulWidget {
  final List< StatusElement> status;
  const ViewStatusScreen({Key? key, required this.status}) : super(key: key);

  @override
  _ViewStatusScreenState createState() => _ViewStatusScreenState();
}

class _ViewStatusScreenState extends State<ViewStatusScreen> {
  final storyController = StoryController();
  List<StoryItem>  storyItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for(StatusElement status in widget.status){
      storyItems.add(    status.file == null?
      StoryItem.text(
        title: status.text!,
        backgroundColor: Colors.blue,
      ): status.mediaType == 'image'?  StoryItem.pageImage(
        url:
        status.file!,
        caption: status.text,
        controller: storyController,
      ): StoryItem.pageVideo(
       status.file! ,
          caption:  status.text,
          controller: storyController),);
    }
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return StoryView(


      storyItems:


storyItems
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
      onStoryShow: (s) {
        print("Showing a story");
      },
      onComplete: () {
        print("Completed a cycle");
        Navigator.pop(context);
      },
      progressPosition: ProgressPosition.top,
      repeat: false,
      controller: storyController,
    );
  }
}
