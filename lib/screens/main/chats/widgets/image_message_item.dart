part of 'message_item.dart';

class ImageMessageItem extends StatefulWidget {
  const ImageMessageItem(
      {Key? key, required this.chatMessage, required this.files})
      : super(key: key);

  final Message chatMessage;
  final List<String> files;

  @override
  State<ImageMessageItem> createState() => _ImageMessageItemState();
}

class _ImageMessageItemState extends State<ImageMessageItem> {
  final CacheCubit _cacheCubit = injector.get<CacheCubit>();

  @override
  Widget build(BuildContext context) {
    CachedUser cachedUser = _cacheCubit.cachedUser!;
    bool isForMe = widget.chatMessage.userId == cachedUser.id.toString();

    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: GestureDetector(
            onTap: (state is! ChatMessageLoading && state is! ChatError)
                ? () => showDialog(
                      context: context,
                      // isDismissible: false,
                      // enableDrag: false,
                      barrierDismissible: true,
                      builder: (context) => ImagePreviewer(
                        imageUrl: widget.chatMessage.media[0].mediaPath!,
                        heroTag: "cover_photo",
                        tightMode: true,
                      ),
                    )
                : null,
            child: Container(
              constraints: const BoxConstraints(
                  // maxHeight: MediaQuery.of(context).size.height * 0.4,
                  // maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
              margin: const EdgeInsets.only(right: 5, left: 5, top: 8),
              decoration: BoxDecoration(
                  color:
                      !isForMe ? Colors.grey.shade300 : AppColors.primaryColor,
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(15)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    state is! ChatMessageLoading && state is! ChatError
                        ? CachedNetworkImage(
                            imageUrl: widget.chatMessage.media[0].mediaPath!,
                            // width: MediaQuery.of(context).size.width,
                            // height: MediaQuery.of(context).size.height,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(widget.chatMessage.media[0].mediaPath!),
                            fit: BoxFit.cover,
                          ),
                    Align(
                      alignment: Alignment.center,
                      child: state is ChatMessageLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator.adaptive())
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
