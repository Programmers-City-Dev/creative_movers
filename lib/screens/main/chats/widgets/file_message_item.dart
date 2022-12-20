part of 'package:creative_movers/screens/main/chats/widgets/message_item.dart';

class _FileMessageItem extends StatefulWidget {
  const _FileMessageItem({Key? key, required this.chatMessage})
      : super(key: key);

  final Message chatMessage;

  @override
  State<_FileMessageItem> createState() => _FileMessageItemState();
}

class _FileMessageItemState extends State<_FileMessageItem> {
  final CacheCubit _cacheCubit = injector.get<CacheCubit>();

  @override
  Widget build(BuildContext context) {
    CachedUser cachedUser = _cacheCubit.cachedUser!;
    bool isForMe = widget.chatMessage.userId == cachedUser.id.toString();
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
              color: !isForMe ? Colors.grey.shade300 : AppColors.primaryColor,
              border: Border.all(color: Colors.grey.shade50, width: 1),
              borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  widget.chatMessage.media[0].type == 'pdf'
                      ? Icons.picture_as_pdf
                      : widget.chatMessage.media[0].type == 'document'
                          ? Icons.description_outlined
                          : Icons.file_present_outlined,
                  color: !isForMe ? AppColors.primaryColor : Colors.white,
                ),
                onPressed: () {},
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                (state is! ChatMessageLoading && state is! ChatError)
                    ? basename(
                        widget.chatMessage.media.first.mediaPath.toString())
                    : basename(
                        widget.chatMessage.media.first.mediaPath.toString()),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: isForMe ? Colors.white : AppColors.primaryColor),
              ),
              const SizedBox(
                width: 10,
              ),
              Icon(
                Icons.download_for_offline_outlined,
                color: !isForMe ? AppColors.primaryColor : Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}
