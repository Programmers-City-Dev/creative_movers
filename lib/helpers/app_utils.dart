import 'dart:developer';

import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:creative_movers/models/ethnicity.dart';
import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/auth/views/login_screen.dart';
import 'package:creative_movers/screens/main/home_screen.dart';
import 'package:creative_movers/screens/main/status/widgets/create_story_dialog.dart';
import 'package:creative_movers/screens/onboarding/views/onboarding_screen.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AppUtils {
  AppUtils._();

  static List<EthnicityModel> get ethnicities {
    Map<String, dynamic> data = {
      "Mixed / Multiple ethnic groups": [
        "White and Black Caribbean",
        "White and Black African",
        "White and Asian",
        "Other Mixed / Multiple ethnic background",
      ],
      "Black / African / Caribbean / Black British": [
        "African",
        "Caribbean",
        "Other Black / African / Caribbean background",
      ],
      "Any other ethnic group": ["Any other ethnic group"]
    };

    List<EthnicityModel> list = [];
    data.forEach((k, v) => list.add(EthnicityModel(title: k, values: v)));
    return list;
  }

  static Future<Widget> getFirstScreen() async {
    bool isFirstTimeUser =
        await StorageHelper.getBoolean(StorageKeys.firsTimeUser, true);
    bool isLoggedIn =
        await StorageHelper.getBoolean(StorageKeys.stayLoggedIn, false);

    String? regStatus =
        await StorageHelper.getString(StorageKeys.registrationStage);

    // String? token =
    // await StorageHelper.getString(StorageKeys.token);
    log("IS FIRST TIME USER: $isFirstTimeUser");
    log("IS LOGGED IN: $isLoggedIn");
    if (isFirstTimeUser) {
      return const OnboardingScreen();
    } else {
      //-----------Login Check--------------
      if (isLoggedIn) {
        return const HomeScreen();
      } else {
        return const LoginScreen();
      }
    }
  }

  static Future<String?> getUserName() async {
    String? username = await StorageHelper.getString(StorageKeys.username);
    return username;
  }

  static Future<String?> getUserId() async {
    String? userId = await StorageHelper.getString(StorageKeys.user_id);
    return userId;
  }

  static String capitalizeFirstCharacter(String s) {
    return toBeginningOfSentenceCase(s)!;
  }

  static String getTime(DateTime date) {
    final DateFormat formatter = DateFormat.jm();
    return formatter.format(date);
  }

  static String getLastSeen(DateTime date) {
    String lastSeen = "";

    if (date.year == DateTime.now().year) {
      String d = DateFormat("E, MMM d").format(date);
      if (date.day == DateTime.now().day) {
        lastSeen = 'Today ';
      } else if (date.day == DateTime.now().day - 1) {
        lastSeen = 'Yesterday ';
      } else {
        lastSeen = d;
      }
      String time = getTime(date);
      return "$lastSeen @ $time";
    }
    String time = getTime(date);
    return "$lastSeen @ $time";
  }

  static String getTimeAgo(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    // DateTime dateTime = DateTime.parse(date);
    Duration duration = DateTime.now().difference(dateTime);

    double months = duration.inDays / 28;
    double years = months / 12;
    log(formatter.format(DateTime.now()));

    if (duration.inMinutes < 1) {
      return ' ${duration.inSeconds.toString()} secs ago';
    } else if (duration.inHours < 1) {
      return ' ${duration.inMinutes.toString()} mins ago';
    } else if (duration.inDays < 1) {
      return '${duration.inHours.toString()} hrs ago';
    } else if (months < 1) {
      if (duration.inDays > 1) {
        return '${duration.inDays.toString()} days ago';
      } else {
        return '${duration.inDays.toString()} day ago';
      }
    } else if (years < 1) {
      return months < 2
          ? '${months.round().toString()} month ago'
          : '${months.round().toString()} months ago';
    } else {
      return '${years.toString()} years ago';
    }
  }

  static void showAnimatedProgressDialog(BuildContext context,
      {String? title}) {
    showGeneralDialog(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      barrierLabel: 'label',
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) => Dialog(
        backgroundColor: AppColors.smokeWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              height: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 30),
                  Flexible(
                    child: Text(
                      title ?? 'Please wait...',
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim),
          child: child,
        );
      },
    );
  }

  static void showCustomToast(String msg, [Color? bgColor, Color? textColor]) =>
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: bgColor ?? Colors.black,
          textColor: textColor ?? AppColors.white,
          fontSize: 16);

  static void cancelAllShowingToasts() => Fluttertoast.cancel();

  static Future<bool> showConfirmDialog(BuildContext context,
      {String? title,
      required String message,
      required String cancelButtonText,
      required String confirmButtonText,
      VoidCallback? onConfirmed,
      VoidCallback? onCancel,
      Color? color,
      bool? isDismissible,
      bool? useRootNavigator = false,
      Widget? icon}) async {
    var val = await showDialog(
      context: context,
      barrierDismissible: isDismissible ?? true,
      useRootNavigator: useRootNavigator!,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title ?? '', style: const TextStyle(color: Colors.black)),
        content: Text(
          message,
          // textAlign: TextAlign.center,
          style: TextStyle(color: color ?? Colors.grey[700]),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(confirmButtonText)),
          TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(cancelButtonText)),
        ],
      ),
    );
    return val;
  }

  static void showErrorDialog(BuildContext context,
      {required String message,
      required String title,
      required String confirmButtonText,
      required VoidCallback onConfirmed,
      Color? color,
      bool? isDismissible,
      Widget? icon}) {
    showDialog(
      context: context,
      barrierDismissible: isDismissible ?? true,
      useRootNavigator: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                icon ??
                    Icon(
                      Icons.error_outline_outlined,
                      size: 52,
                      color: color ?? Colors.red,
                    ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.red,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 32,
                )
              ],
            ),
            if (icon != null)
              const SizedBox(
                height: 32.0,
              ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: color ?? Colors.grey[600]),
            ),
            const SizedBox(
              height: 32.0,
            ),
            CustomButton(onTap: onConfirmed, child: Text(confirmButtonText)),
          ],
        ),
      ),
    );
  }

  static Size getDeviceSize(BuildContext context) =>
      MediaQuery.of(context).size;

  static void showSuccessSuccessDialog(BuildContext context,
      {String? title, String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppIcons.svgGood,
              width: 100,
              height: 100,
            ),
            const SizedBox(
              height: 32.0,
            ),
            if (title != null)
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            if (title != null)
              const SizedBox(
                height: 32.0,
              ),
            Text(
              '$message',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textColor, fontSize: 13),
            ),
            const SizedBox(
              height: 32.0,
            ),
            CustomButton(
              child: const Text('OK'),
              onTap: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }

  static void showLoaderDialog(BuildContext context,
      {bool? barrierDismissible = true,
      bool isDissmissible = false,
      bool? useRootNavigator = false,
      String? message}) {
    showDialog(
        context: context,
        barrierDismissible: barrierDismissible!,
        useRootNavigator: useRootNavigator!,
        barrierColor: Colors.black.withOpacity(0.5),
        builder: (_) {
          return Material(
            color: Colors.transparent,
            child: WillPopScope(
              onWillPop: () => Future.value(isDissmissible),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.all(16),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: SpinKitFadingCircle(
                          itemBuilder: (BuildContext context, int index) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index.isEven ? Colors.red : Colors.green,
                              ),
                            );
                          },
                        ),
                      )),
                ],
              ),
            ),
          );
        });
  }

  static void showMessageDialog(BuildContext context,
      {String? title, String? message, required VoidCallback onClose}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/pngs/sorry.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(
              height: 18.0,
            ),
            if (title != null)
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            if (title != null)
              const SizedBox(
                height: 32.0,
              ),
            Text(
              '$message',
              textAlign: TextAlign.center,
              style: const TextStyle(),
            ),
            const SizedBox(
              height: 32.0,
            ),
            CustomButton(
              onTap: onClose,
              child: const Text('CONTINUE'),
            )
          ],
        ),
      ),
    );
  }

  static void showStoryDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return const CreateStoryDialog();
      },
    );
  }

  static Future<List<String>> fetchFiles(
      {bool allowMultiple = false,
      String? title,
      FileType fileType = FileType.image,
      List<String>? allowedExtensions}) async {
    try {
      FilePicker filePicker = FilePicker.platform;
      FilePickerResult? result = await filePicker.pickFiles(
        type: fileType,
        allowCompression: true,
        dialogTitle: title ?? 'SELECT IMAGES',
        withData: true,
        allowMultiple: allowMultiple,
        allowedExtensions: allowedExtensions,
      );
      if (result != null) {
        return result.files.map((file) => file.path!).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<String?> fetchImageFromCamera() async {
    try {
      var pickedFile = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 70);
      if (pickedFile != null) {
        return pickedFile.path;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static selectFiles(BuildContext context, Function(List<String>) onSelected,
      {bool allowMultiple = false,
      bool hasViewAction = false,
      String? title,
      FileType? fileType,
      List<String>? allowedExtensions,
      VoidCallback? onViewAction}) async {
    await showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        backgroundColor: AppColors.smokeWhite,
        builder: (context) {
          return Container(
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: <Widget>[
                InkWell(
                  child: Container(
                      padding: const EdgeInsets.all(16),
                      color: AppColors.white,
                      child: const Text('Take a photo',
                          textAlign: TextAlign.center)),
                  onTap: () {
                    Navigator.pop(context);
                    fetchImageFromCamera().then((value) {
                      if (null != value) {
                        return onSelected([value]);
                      }
                    });
                  },
                ),
                const SizedBox(height: 1),
                InkWell(
                  child: Container(
                      padding: const EdgeInsets.all(16),
                      color: AppColors.white,
                      child: const Text('Select from Gallery',
                          textAlign: TextAlign.center)),
                  onTap: () async {
                    Navigator.pop(context);
                    var list = await fetchFiles(
                        allowMultiple: allowMultiple,
                        fileType: fileType ?? FileType.image,
                        title: title,
                        allowedExtensions: allowedExtensions);
                    onSelected(list);
                  },
                ),
                if (hasViewAction)
                  Column(
                    children: [
                      const SizedBox(height: 1),
                      InkWell(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(16),
                            color: AppColors.white,
                            child: const Text('View Photo',
                                textAlign: TextAlign.center)),
                        onTap: () {
                          Navigator.pop(context);
                          if (onViewAction != null && hasViewAction) {
                            onViewAction();
                          }
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                InkWell(
                  child: Container(
                      padding: const EdgeInsets.all(16),
                      color: AppColors.white,
                      child: const Text('Cancel', textAlign: TextAlign.center)),
                  onTap: () {
                    Navigator.pop(context);
                    // _openCamera();
                  },
                ),
              ],
            ),
          );
        });
  }

  static Future<List<Map<String, String?>>> fetchVideos(
      {bool allowMultiple = false}) async {
    try {
      FilePicker filePicker = FilePicker.platform;
      FilePickerResult? result = await filePicker.pickFiles(
        type: FileType.video,
        allowCompression: true,

        allowMultiple: allowMultiple,
        // allowedExtensions: ['mp4'],
      );
      if (result != null) {
        return result.files
            .map((file) => {'path': file.path, 'size': file.size.toString()})
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<PlatformFile>> fetchMedia(
      {bool allowMultiple = false,
      Function(FilePickerResult? result)? onSelect}) async {
    try {
      FilePicker filePicker = FilePicker.platform;
      FilePickerResult? result = await filePicker.pickFiles(
        type: FileType.custom,
        allowCompression: true,
        allowMultiple: allowMultiple,
        allowedExtensions: [
          'mp4',
          'mov',
          'jpg',
          'jpeg',
          'png',
          'pdf',
          'doc',
          'docx'
        ],
      );
      //     .then((value) {
      //   onSelect!(value);
      //   return null;
      // });
      if (result != null) {
        return result.files;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static String getDateAndTime(DateTime createdAt) {
    return DateFormat("MMMM dd, yyyy hh:mm a").format(createdAt);
  }

  static String formatTimeAgo(DateTime date) {
    if (date.day == DateTime.now().day) {
      return 'Today ${DateFormat("hh:mm a").format(date)}';
    } else if (date.day == DateTime.now().day - 1) {
      return 'Yesterday ${DateFormat("hh:mm a").format(date)}';
    }

    return DateFormat.yMMMEd().format(date);
  }

  static String getGroupLabel(int groupByValue) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(groupByValue);
    if (date.day == DateTime.now().day) {
      return 'Today';
    } else if (date.day == DateTime.now().day - 1) {
      return 'Yesterday';
    }

    return DateFormat.yMMMEd()
        .format(DateTime.fromMillisecondsSinceEpoch(groupByValue));
  }

  static formatMoney(num value, [String? currency]) {
    return NumberFormat.simpleCurrency(
            locale: 'en_US', decimalDigits: 2, name: currency ?? '')
        .format(value);
  }

  static Future<void> launchInAppBrowser(
      BuildContext context, String url) async {
    try {
      return launch(
        url,
        customTabsOption: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: false,
          enableUrlBarHiding: false,
          showPageTitle: false,
          animation: CustomTabsSystemAnimation.slideIn(),
          extraCustomTabs: const <String>[
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
// An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
      return Future.error("error");
    }
  }

  static String formatDateTime(int? t) {
    return DateFormat("E MMM d, yyyy・h:mm a")
        .format(DateTime.fromMillisecondsSinceEpoch(t!));
  }

  static void showUpgradeDialog(BuildContext context,
      {required VoidCallback onSubscribe}) async {
    showMaterialModalBottomSheet(
        context: context,
        expand: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        builder: (_) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Upgrade",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22)),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        const Text(
                            "Oops! you don't have permission to access this feature, "
                            "please upgrade your account to enjoy this feature",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16)),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomButton(
                          child: const Text('Subscribe Now'),
                          onTap: () {
                            onSubscribe.call();
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ));
  }
}

class CustomSnackBar {
  final BuildContext context;

  CustomSnackBar({required this.context});

  CustomSnackBar.showMessage(
    this.context, {
    required String message,
    Function? action,
    String? actionMessage,
    Color? backgroundColor,
  }) {
    final snackBar = SnackBar(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      action: action == null
          ? null
          : SnackBarAction(
              label: actionMessage ?? "OK",
              onPressed: () => action,
              textColor: Theme.of(context).colorScheme.primary,
            ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        // side: BorderSide(
        //     width: 1, color: Theme.of(context).colorScheme.primary)
      ),
      backgroundColor: AppColors.darkBlue,
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
          color: Colors.white,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  CustomSnackBar.show(
    this.context, {
    required Widget body,
    Function? action,
    String? actionMessage,
    Color? backgroundColor,
  }) {
    final snackBar = SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(18),
      duration: const Duration(seconds: 5),
      dismissDirection: DismissDirection.horizontal,
      action: action == null
          ? null
          : SnackBarAction(
              label: actionMessage ?? "OK",
              onPressed: () => action,
              textColor: Colors.white,
            ),
      backgroundColor: Colors.black,
      content: body,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,
    );
  }

  CustomSnackBar.showError(
    this.context, {
    required String message,
    Function? action,
    String? actionMessage,
    Color? backgroundColor,
  }) {
    final snackBar = SnackBar(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      action: action == null
          ? null
          : SnackBarAction(
              label: actionMessage ?? "OK",
              onPressed: () => action,
              textColor: Colors.white,
            ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: backgroundColor ?? backgroundColor ?? Colors.red,
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  CustomSnackBar.showSuccess(
    this.context, {
    required String message,
    Function? action,
    String? actionMessage,
    Color? backgroundColor,
  }) {
    final snackBar = SnackBar(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      action: action == null
          ? null
          : SnackBarAction(
              label: actionMessage ?? "OK",
              onPressed: () => action,
              textColor: Colors.white,
            ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: backgroundColor ?? backgroundColor ?? Colors.green,
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
          color: Colors.white,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
