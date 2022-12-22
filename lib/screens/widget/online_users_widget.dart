import 'package:creative_movers/blocs/chat/chat_bloc.dart';
import 'package:creative_movers/data/local/model/cached_user.dart';
import 'package:creative_movers/data/remote/model/chat/conversation.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/screens/main/chats/views/messaging_screen.dart';
import 'package:creative_movers/screens/main/status/widgets/status_shimmer.dart';
import 'package:creative_movers/screens/widget/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'circle_image.dart';

class OnlineUsers extends StatefulWidget {
  final CachedUser cachedUser;
  final ValueNotifier<bool> onlineUsersNotifier;

  const OnlineUsers(this.cachedUser, this.onlineUsersNotifier, {Key? key})
      : super(key: key);

  @override
  OnlineUsersState createState() => OnlineUsersState();
}

class OnlineUsersState extends State<OnlineUsers> {
  final ChatBloc _chatBloc = ChatBloc(injector.get());

  @override
  void initState() {
    super.initState();
    _chatBloc.add(FetchOnlineUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      bloc: _chatBloc,
      builder: (context, state) {
        if (state is OnlineUsersFetched) {
          List<ConversationUser> users = state.users;
          return ValueListenableBuilder<bool>(
              valueListenable: widget.onlineUsersNotifier,
              builder: (context, value, child) {
                if (value) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    _chatBloc.add(FetchOnlineUsersEvent());
                    widget.onlineUsersNotifier.value = false;
                  });
                }
                return users.isNotEmpty
                    ? Container(
                        height: 100,
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        alignment: Alignment.center,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: users.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                builder: (context) => MessagingScreen(
                                    conversationId: null, user: users[index]),
                              ));
                            },
                            child: SizedBox(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: CircleImage(
                                      url: users[index].profilePhotoPath,
                                      withBaseUrl: false,
                                      radius: 28,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Center(
                                        child: Text(
                                      '${users[index].firstname}',
                                      maxLines: 1,
                                      style: const TextStyle(fontSize: 13),
                                    )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              });
        }
        if (state is ChatError) {
          return Center(
            child: AppPromptWidget(
              message: state.errorModel.errorMessage,
              onTap: () => _chatBloc.add(FetchOnlineUsersEvent()),
            ),
          );
        }
        if (state is ChatMessageLoading) {
          return const SizedBox(height: 100, child: StatusShimmer());
        }
        return const SizedBox.shrink();
      },
    );
  }
}
