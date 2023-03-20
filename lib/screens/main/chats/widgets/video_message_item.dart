import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/chat/chat_bloc.dart';
import 'package:creative_movers/data/local/model/cached_user.dart';
import 'package:creative_movers/data/remote/model/chat/conversation.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/screens/widget/video_thumbnail_builder.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feed/widgets/video_preview_dialog.dart';

class VideoMessageItem extends StatefulWidget {
  const VideoMessageItem({Key? key, required this.chatMessage})
      : super(key: key);
  final Message chatMessage;

  @override
  State<VideoMessageItem> createState() => _VideoMessageItemState();
}

class _VideoMessageItemState extends State<VideoMessageItem> {
  final CacheCubit _cacheCubit = injector.get<CacheCubit>();

  // VideoPlayerController? _controller;

  @override
  Widget build(BuildContext context) {
    CachedUser cachedUser = _cacheCubit.cachedUser!;
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Container(
          height: 200,
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(children: [
              VideoThumnailBuilder(
                videoUrl: widget.chatMessage.media[0].mediaPath!,
                builder: (context, imageUrl) {
                  return SizedBox(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: Image.memory(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => VideoPreview(
                          videoUrl: widget.chatMessage.media[0].mediaPath!));
                },
                child: SizedBox(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
