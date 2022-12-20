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
              height: 220,
              width: 170,
              margin: const EdgeInsets.only(right: 5, left: 5, top: 8),
              decoration: BoxDecoration(
                  color:
                      !isForMe ? Colors.grey.shade300 : AppColors.primaryColor,
                  border: Border.all(color: Colors.grey, width: 1),
                  image: DecorationImage(
                      colorFilter: null,
                      fit: BoxFit.cover,
                      image: (state is! ChatMessageLoading &&
                              state is! ChatError)
                          ? NetworkImage(widget.chatMessage.media[0].mediaPath!)
                          : FileImage(
                              File(widget.files[0]),
                            ) as ImageProvider),
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: state is ChatMessageLoading
                    ? const CircularProgressIndicator()
                    : const SizedBox(),
              ),
            ),
          ),
        );
      },
    );
  }
}
