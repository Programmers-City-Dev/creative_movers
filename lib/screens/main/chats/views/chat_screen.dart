import 'dart:developer';

import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/chat/chat_bloc.dart';
import 'package:creative_movers/blocs/connects/conects_bloc.dart';
import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/data/local/model/cached_user.dart';
import 'package:creative_movers/data/remote/model/chat/conversation.dart';
import 'package:creative_movers/data/remote/model/get_connects_response.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:creative_movers/screens/auth/views/connection_screen.dart';
import 'package:creative_movers/screens/main/chats/views/messaging_screen.dart';
import 'package:creative_movers/screens/main/chats/widgets/chat_item.dart';
import 'package:creative_movers/screens/main/chats/widgets/chats_loader.dart';
import 'package:creative_movers/screens/main/contacts/widgets/connects_shimer.dart';
import 'package:creative_movers/screens/widget/circle_image.dart';
import 'package:creative_movers/screens/widget/error_widget.dart';
import 'package:creative_movers/screens/widget/online_users_widget.dart';
import 'package:creative_movers/screens/widget/search_field.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatBloc _chatBloc = injector.get<ChatBloc>();
  final CacheCubit _cacheCubit = injector.get<CacheCubit>();

  final ValueNotifier<bool> _onlineUsersNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _cacheCubit.fetchCachedUserData();
    _chatBloc.add(FetchConversationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showConnectionsDialog(context);
        },
        child: const Icon(Icons.chat),
      ),
      body: SafeArea(
        child: BlocBuilder<CacheCubit, CacheState>(
          bloc: _cacheCubit,
          buildWhen: (_, state) => state is CachedUserDataFetched,
          builder: (context, state) {
            if (state is CachedUserDataFetched) {
              CachedUser cachedUser = (state).cachedUser;
              StorageHelper.getString(StorageKeys.token)
                  .then((value) => log("TOKEN: $value"));
              return RefreshIndicator(
                onRefresh: () async {
                  _chatBloc.add(FetchConversationsEvent());
                  _onlineUsersNotifier.value = true;
                },
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: SearchField(
                            hint: 'Search Chats',
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.people,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    OnlineUsers(cachedUser, _onlineUsersNotifier),
                    BlocBuilder<ChatBloc, ChatState>(
                      bloc: _chatBloc,
                      builder: (context, state) {
                        if (state is ChatMessageLoading) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (context, index) =>
                                  const ChatsLoader(),
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(
                                  height: 14,
                                );
                              },
                            ),
                          );
                        }
                        if (state is ChatError) {
                          return Center(
                              child: AppPromptWidget(
                            onTap: () {
                              _chatBloc.add(FetchConversationsEvent());
                            },
                            canTryAgain: true,
                            isSvgResource: true,
                            imagePath: "assets/svgs/request.svg",
                            title: "Something went wrong",
                            message: state.errorModel.errorMessage,
                          ));
                        }
                        if (state is ConversationsFetched) {
                          List<Conversation> conversation = state.conversations;
                          if (conversation.isEmpty) {
                            return Center(
                                child: AppPromptWidget(
                              onTap: () {
                                _showConnectionsDialog(context);
                              },
                              canTryAgain: true,
                              isSvgResource: true,
                              buttonText: "Create New",
                              imagePath: "assets/svgs/request.svg",
                              title: "Conversations empty",
                              message:
                                  "Chose a connection to start a conversation.",
                            ));
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) => ChatItem(
                                conversation: conversation[index],
                                userId: cachedUser.id),
                            itemCount: conversation.length,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    )
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<dynamic> _showConnectionsDialog(BuildContext context) {
    final ConnectsBloc _connectsBloc = ConnectsBloc();
    return showBarModalBottomSheet(
        context: context,
        useRootNavigator: true,
        expand: false,
        builder: (ctx) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Select a connection',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Flexible(
                  child: BlocBuilder<ConnectsBloc, ConnectsState>(
                    bloc: _connectsBloc..add(GetConnectsEvent()),
                    builder: (context, state) {
                      if (state is ConnectsLoadingState) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 60,
                              itemBuilder: (ctx, i) {
                                return const ConnectsShimer();
                              }),
                        );
                      }
                      if (state is ConnectsFailureState) {
                        return Center(
                            child: AppPromptWidget(
                          onTap: () {
                            _chatBloc.add(FetchConversationsEvent());
                          },
                          canTryAgain: true,
                          isSvgResource: true,
                          imagePath: "assets/svgs/request.svg",
                          title: "Something went wrong",
                          message: state.error,
                        ));
                      }
                      if (state is ConnectsSuccesState) {
                        List<Connection> connections =
                            state.connectsResponse.connections.connectionList;
                        if (connections.isEmpty) {
                          return const Center(
                              child: AppPromptWidget(
                            canTryAgain: false,
                            isSvgResource: true,
                            imagePath: "assets/svgs/request.svg",
                            title: "Connections empty",
                            message: "Invite connections to get started",
                          ));
                        }
                        return ListView.builder(
                          // shrinkWrap: true,
                            itemCount: connections.length,
                            itemBuilder: (ctx, index) {
                              return ListTile(
                                onTap: () {
                                  log("ID Chaek: ${connections[index].toJson()}");
                                  Navigator.of(context).pop();
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (ctx) => MessagingScreen(
                                                conversationId:
                                                    connections[index]
                                                        .conversationId,
                                                user: ConversationUser(
                                                    id: int.parse(
                                                        connections[index]
                                                            .userId),
                                                    profilePhotoPath:
                                                        connections[index]
                                                            .profilePhotoPath,
                                                    username: connections[index]
                                                        .username,
                                                    firstname:
                                                        connections[index]
                                                            .firstname,
                                                    lastname: connections[index]
                                                        .lastname,
                                                    updatedAt:
                                                        connections[index]
                                                            .updatedAt),
                                              )));
                                },
                                leading: CircleImage(
                                  radius: 24,
                                  url: connections[index].profilePhotoPath,
                                  withBaseUrl: false,
                                ),
                                title: Text(
                                  connections[index].fullName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                subtitle: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: '@${connections[index].username}',
                                        style: const TextStyle(
                                            color: AppColors.grey,
                                            fontSize: 12)),
                                    const TextSpan(
                                        text: '・',
                                        style: TextStyle(
                                            color: AppColors.grey,
                                            fontSize: 12)),
                                    TextSpan(
                                        text: connections[index].role,
                                        style: const TextStyle(
                                            color: AppColors.grey,
                                            fontSize: 12))
                                  ]),
                                ),
                              );
                            });
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
}
