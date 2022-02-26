import 'package:creative_movers/blocs/connects/conects_bloc.dart';
import 'package:creative_movers/data/remote/model/search_response.dart';
import 'package:creative_movers/helpers/app_utils.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_stack/image_stack.dart';

enum ConnectState { idle, success, loading }

class ResultItem extends StatefulWidget {
  const ResultItem({Key? key, required this.result}) : super(key: key);
  final Result result;

  @override
  _ResultItemState createState() => _ResultItemState();
}

class _ResultItemState extends State<ResultItem> with AutomaticKeepAliveClientMixin{
  List<String> images = [
    'https://i.pinimg.com/736x/d2/b9/67/d2b967b386e178ee3a148d3a7741b4c0.jpg',
    'https://www.dmarge.com/wp-content/uploads/2021/01/dwayne-the-rock-.jpg'
  ];
  ConnectsBloc _connectsBloc = ConnectsBloc();
  ConnectsBloc _connectsBloc2 = ConnectsBloc();
  ConnectState connectState = ConnectState.idle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 31,
              foregroundColor: Colors.red,
              backgroundImage: NetworkImage(
                widget.result.profilePhotoPath!,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.result.firstname}  ${widget.result
                                .lastname} ',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                          Text(
                            widget.result.role.name,
                            // widget.result!.role!,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        BlocListener<ConnectsBloc, ConnectsState>(
                          bloc: _connectsBloc,
                          listener: (context, state) {
                            listenToSendRequestState(context, state);
                            // TODO: implement listener
                          },
                          child: widget.result.connected == 'Not Connected' ?
                          TextButton(
                            onPressed: connectState != ConnectState.loading
                                ? () {
                              connectState = ConnectState.loading;
                              _connectsBloc.add(SendRequestEvent(
                                  widget.result.id.toString()));
                            }
                                : null,
                            child: connectState == ConnectState.idle
                                ? Text('Connect')
                                : connectState == ConnectState.loading
                                ? const SizedBox(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                                strokeWidth: 2,
                              ),
                              height: 10,
                              width: 10,
                            )
                                : Text('Pending..'),
                            style: TextButton.styleFrom(
                                backgroundColor: AppColors.lightBlue),
                          ) :
                          widget.result.connected == 'Connected' ?  TextButton(
                            onPressed: () {},
                            child: const Text('Connected'),
                            style: TextButton.styleFrom(
                                backgroundColor: AppColors.lightBlue),
                          )
                          : TextButton(
                            onPressed: () {},
                            child: const Text('Pending..'),
                            style: TextButton.styleFrom(
                                backgroundColor: AppColors.lightBlue),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        !widget.result.following
                            ? BlocConsumer<ConnectsBloc, ConnectsState>(
                          listener: (context, state) {
                            listenToFollowState(context, state);
                          },
                          bloc: _connectsBloc2,
                          builder: (context, state) {
                            return state is FollowLoadingState
                                ? Container(
                              width: 10,
                              height: 10,
                              child:
                              const CircularProgressIndicator(
                                color: AppColors.primaryColor,
                                strokeWidth: 2,
                              ),
                            )
                                : state is FollowSuccesState
                                ? InkWell(
                              onTap: () {
                                _connectsBloc2.add(FollowEvent(
                                    user_id: widget.result.id
                                        .toString()));
                              },
                              child: SvgPicture.asset(
                                'assets/svgs/added.svg',
                                color: AppColors.primaryColor,
                              ),
                            )
                                : InkWell(
                              onTap: () {
                                _connectsBloc2.add(FollowEvent(
                                    user_id: widget.result.id
                                        .toString()));
                              },
                              child: const Icon(
                                Icons.person_add,
                                color: AppColors.primaryColor,
                              ),
                            );
                          },
                        )
                            : SvgPicture.asset(
                          'assets/svgs/added.svg',
                          color: AppColors.primaryColor,
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    ImageStack(
                      imageList: images,
                      totalCount: images.length,
                      // If larger than images.length, will show extra empty circle
                      imageRadius: 20,
                      // Radius of each images
                      imageCount: 3,
                      // Maximum number of images to be shown in stack
                      imageBorderWidth: 3, // Border width around the images
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      'Peter C. ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('+ are following'),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void listenToSendRequestState(BuildContext context, ConnectsState state) {
    if (state is SendRequestLoadingState) {
      setState(() {
        connectState = ConnectState.loading;

      });
    }
    if (state is SendRequestSuccesState) {
      setState(() {
        connectState = ConnectState.success;
        AppUtils.showCustomToast('Request Sent');
      });
    }
    if (state is SendRequestFailureState) {
      setState(() {
        AppUtils.showCustomToast(state.error);
        connectState = ConnectState.idle;
      });
    }
  }

  void listenToFollowState(BuildContext context, ConnectsState state) {
    if (state is FollowLoadingState) {}
    if (state is FollowSuccesState) {
      // AppUtils.showCustomToast('Request Sent');

    }
    if (state is FollowFailureState) {
      AppUtils.showCustomToast(state.error);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


}

class StackedImages extends StatefulWidget {
  const StackedImages({Key? key, required this.user}) : super(key: key);
  final Result user;


  @override
  _StackedImagesState createState() => _StackedImagesState();
}

class _StackedImagesState extends State<StackedImages> {
  List<String> images = [];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ImageStack(

          imageList: images,
          totalCount: images.length,
          // If larger than images.length, will show extra empty circle
          imageRadius: 20,
          // Radius of each images
          imageCount: 3,
          // Maximum number of images to be shown in stack
          imageBorderWidth: 3,
          // Border width around the images
        ),
        const SizedBox(
          width: 5,
        ),
        const Text(
          'Peter C. ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('+ are following'),
      ],
    );
  }
}

