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
  late String _localPath = '';
  late bool _permissionReady;

  @override
  Widget build(BuildContext context) {
    CachedUser cachedUser = _cacheCubit.cachedUser!;
    bool isForMe = widget.chatMessage.userId == cachedUser.id.toString();
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {},
      builder: (context, state) {
        return InkWell(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
                color: !isForMe ? Colors.grey.shade300 : AppColors.primaryColor,
                border: Border.all(color: Colors.grey.shade50, width: 1),
                borderRadius: BorderRadius.circular(15)),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  child: Icon(
                    widget.chatMessage.media[0].type == 'pdf'
                        ? Icons.picture_as_pdf
                        : widget.chatMessage.media[0].type == 'document'
                            ? Icons.description_outlined
                            : Icons.file_present_outlined,
                    color: !isForMe ? AppColors.primaryColor : Colors.white,
                  ),
                  onTap: () {},
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                    flex: 1,
                    child: Text(
                      (state is! ChatMessageLoading && state is! ChatError)
                          ? basename(widget.chatMessage.media.first.mediaPath
                              .toString())
                          : basename(widget.chatMessage.media.first.mediaPath
                              .toString()),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color:
                              isForMe ? Colors.white : AppColors.primaryColor),
                    )),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () async {
                      if (state is! ChatMessageLoading || state is! ChatError) {
                        await downloadFile(
                            widget.chatMessage.media[0].mediaPath!);
                      }
                    },
                    icon: Icon(
                      Icons.download_for_offline_outlined,
                      color: !isForMe ? AppColors.primaryColor : Colors.white,
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      AppUtils.showCustomToast(progress.toString());
      setState(() {});
    });

    _prepare();
    FlutterDownloader.registerCallback(downloadCallback, step: 1);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
    // log(taskId.toString());
    log(progress.toString());
  }

  Future downloadFile(String url) async {
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      headers: {},
      // optional: header send with url (auth token etc)
      savedDir: _localPath,
      showNotification: true,
      // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );


  }

  Future<void> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    if (tasks == null) {
      log('No tasks were retrieved from the database.');
      return;
    }

    var count = 0;

    _permissionReady = await _checkPermission();
    if (_permissionReady) {
      await _prepareSaveDir();
    }
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _getSavedDir())!;
    final savedDir = Directory(_localPath);
    if (!savedDir.existsSync()) {
      await savedDir.create();
    }
  }

  Future<String?> _getSavedDir() async {
    String? externalStorageDirPath;

    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (err, st) {
        print('failed to get downloads path: $err, $st');

        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  Future<bool> _checkPermission() async {
    if (Platform.isIOS) {
      return true;
    }

    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt > 28) {
        return true;
      }

      final status = await Permission.storage.status;
      if (status == PermissionStatus.granted) {
        return true;
      }

      final result = await Permission.storage.request();
      return result == PermissionStatus.granted;
    }

    throw StateError('unknown platform');
  }
}
