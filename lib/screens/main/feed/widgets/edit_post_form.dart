import 'package:creative_movers/data/remote/model/feedsResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../../blocs/feed/feed_bloc.dart';
import '../../../../helpers/app_utils.dart';
import '../../../widget/custom_button.dart';

class EditPostForm extends StatefulWidget {
  const EditPostForm({Key? key, required this.feed, required this.onSucces}) : super(key: key);
  final Feed feed;
  final VoidCallback onSucces;

  @override
  _EditPostFormState createState() => _EditPostFormState();
}

class _EditPostFormState extends State<EditPostForm> {
  final _contentController = TextEditingController();
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
          AppUtils.showAnimatedProgressDialog(
              context,
              title: "Updating, please wait...");
        }
        if (state is EditFeedSuccessState) {
          widget.onSucces();
          Navigator.of(context).pop();
          // AppUtils.cancelAllShowingToasts();
          AppUtils.showCustomToast(
              "Post has been updated successfully");

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
              color: Theme
                  .of(context)
                  .cardColor,
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

                    bottom: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom),
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
              CustomButton(
                onTap: () {
                  if (_fieldKey.currentState!.validate()) {
                    _feedBloc.add(EditFeedEvent(
                        feed_id: widget.feed.id.toString(),
                        content: _contentController.text,
                        pageId: widget.feed.type == 'page_feed' ? widget.feed
                            .pageId : null));
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
}
