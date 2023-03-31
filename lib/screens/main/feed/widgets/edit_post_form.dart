import 'package:creative_movers/data/remote/model/feeds_response.dart';
import 'package:creative_movers/screens/main/feed/widgets/video_picker_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../../blocs/feed/feed_bloc.dart';
import '../../../../helpers/app_utils.dart';
import '../../../widget/custom_button.dart';
import '../models/mediaitem_model.dart';
import 'image_picker_item.dart';

class EditPostForm extends StatefulWidget {
  const EditPostForm({Key? key, required this.feed, required this.onSucces})
      : super(key: key);
  final Feed feed;
  final VoidCallback onSucces;

  @override
  _EditPostFormState createState() => _EditPostFormState();
}

class _EditPostFormState extends State<EditPostForm> {
  final _contentController = TextEditingController();
  List<String> pickedImages = [];
  List<MediaItemModel> mediaItems = [];
  List<String> mediaFiles = [];

  final GlobalKey<FormState> _fieldKey = GlobalKey<FormState>();

  @override
  void initState() {
    _contentController.text =
        widget.feed.content == null ? '' : widget.feed.content!;
    super.initState();
  }

  final _feedBloc = FeedBloc();

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedBloc, FeedState>(
      bloc: _feedBloc,
      listener: (context, state) {
        if (state is EditFeedLoadingState) {
          AppUtils.showAnimatedProgressDialog(context, title: "Updating, please wait...");
        }
        if (state is EditFeedSuccessState) {
          widget.onSucces();
          Navigator.of(context).pop();
          // AppUtils.cancelAllShowingToasts();
          AppUtils.showCustomToast("Post has been updated successfully");
        }
        if (state is EditFeedFaliureState) {
          Navigator.of(context).pop();
          AppUtils.showCustomToast(state.error);
        }
      },
      child: Container(
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: Container(
                color: Colors.grey,
                width: 100,
                height: 2.5,
              )),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Edit Post',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _fieldKey,
                  child: TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Content must not be empty'),
                      // EmailValidator(errorText: 'Enter a valid email'),
                    ]),
                    controller: _contentController,
                    maxLines: 5,
                    minLines: 1,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        focusedBorder: OutlineInputBorder(),
                        hintText: 'Edit post',
                        border: OutlineInputBorder()),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    _fetchMedia();
                  },
                  child: mediaItems.isNotEmpty
                      ? Column(
                          children: [
                            SizedBox(
                                height: 150,
                                child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: mediaItems.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) => mediaItems[index]
                                        .mediaType ==
                                        MediaType.image
                                        ? ImagePickerItem(
                                      image: mediaItems[index].path,
                                      onClose: () {
                                        setState(() {
                                          mediaItems.remove(mediaItems[index]);
                                          mediaFiles.removeAt(index);
                                        });
                                      },
                                    )
                                        : VideoPickerItem(
                                      path: mediaItems[index].path!,
                                      onClose: () {
                                        setState(() {
                                          mediaFiles.removeAt(index);
                                          mediaItems.remove(mediaItems[index]);
                                        });
                                      },
                                    ))),
                            const Text(
                              'Tap to add image',
                              style: TextStyle(color: Colors.blueGrey),
                            )
                          ],
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Theme.of(context).cardColor),
                          child: Center(
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/pngs/upload_image.png',
                                  height: 200,
                                ),
                                const Text(
                                  'Tap To Upload Image',
                                  style: TextStyle(
                                      color: Colors.blueGrey, fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                onTap: () {
                  if (_fieldKey.currentState!.validate()) {
                    _feedBloc.add(EditFeedEvent(
                        feed_id: widget.feed.id.toString(),
                        content: _contentController.text,
                        pageId: widget.feed.type == 'page_feed'
                            ? widget.feed.pageId
                            : null,
                        media: mediaFiles));

                    // _profileBloc.add(UpdateProfileEvent(phone: _phoneNumberController.text));
                    // _authBloc.add(ForgotPasswordEvent(email: _phoneNumberController.text));

                  }
                },
                child: const Text('Continue'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _fetchMedia() async {
    var images = ['jpg', 'jpeg', 'png', 'webp', 'PNG'];
    var videos = ['mp4', 'mov'];
    var files = await AppUtils.fetchMedia(
        allowMultiple: true,
        onSelect: (result) {
          if (result!.files.isNotEmpty) {
            for (var file in result.files) {
              if (images
                  .where((element) => element == file.extension)
                  .isNotEmpty) {
                mediaItems.add(MediaItemModel(
                    mediaType: MediaType.image, path: file.path));
                mediaFiles.add(file.path!);

                setState(() {});
              } else if (videos
                  .where((element) => element == file.extension)
                  .isNotEmpty) {
                mediaItems.add(MediaItemModel(
                    mediaType: MediaType.video, path: file.path));
                mediaFiles.add(file.path!);
                // log('VIDEO ${mediaFiles[0].file?.filename}');

                setState(() {});
              }
            }
          }
        });
  }
}
