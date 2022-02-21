import 'dart:developer';
import 'dart:io';

import 'package:creative_movers/constants/storage_keys.dart';
import 'package:creative_movers/helpers/storage_helper.dart';
import 'package:creative_movers/screens/auth/views/login_screen.dart';
import 'package:creative_movers/screens/main/home_screen.dart';
import 'package:creative_movers/screens/onboarding/views/onboarding_screen.dart';
import 'package:creative_movers/screens/widget/custom_button.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppUtils {
  AppUtils._();

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
          textColor: textColor ?? Colors.white,
          fontSize: 16);

  static void cancelAllShowingToasts() => Fluttertoast.cancel();

  static void showShowConfirmDialog(BuildContext context,
      {required String message,
      required String cancelButtonText,
      required String confirmButtonText,
      required VoidCallback onConfirmed,
      required VoidCallback onCancel,
      Color? color,
      bool? isDismissible,
      Widget? icon}) {
    showDialog(
      context: context,
      barrierDismissible: isDismissible ?? true,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) icon,
            if (icon != null)
              const SizedBox(
                height: 32.0,
              ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: color ?? Colors.grey[500]),
            ),
            const SizedBox(
              height: 32.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: CustomButton(
                      child: Text(confirmButtonText), onTap: onConfirmed),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(child: CustomButton(child: Text(cancelButtonText), onTap: onCancel)),
              ],
            )
          ],
        ),
      ),
    );
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
            CustomButton(child: Text(confirmButtonText), onTap: onConfirmed),
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
              'assets/images/icons/check_success.svg',
              width: 150,
              height: 150,
            ),
            const SizedBox(
              height: 32.0,
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
              style: const TextStyle(color: AppColors.lightGrey),
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
              child: const Text('CONTINUE'),
              onTap: onClose,
            )
          ],
        ),
      ),
    );
  }

  static Future<List<String>> fetchImages({bool allowMultiple = false}) async {
    try {
      FilePicker filePicker = FilePicker.platform;
      FilePickerResult? result = await filePicker.pickFiles(
        type: FileType.image,
        allowCompression: true,
        dialogTitle:'SELECT IMAGE' ,
        withData: true,
        allowMultiple: allowMultiple,
        // allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
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

  static Future<List<Map<String,String?>>> fetchVideos({bool allowMultiple = false}) async {
    try {
      FilePicker filePicker = FilePicker.platform;
      FilePickerResult? result = await filePicker.pickFiles(
        type: FileType.video,
        allowCompression: true,

        allowMultiple: allowMultiple,
        // allowedExtensions: ['mp4'],

      );
      if (result != null) {
        return result.files.map((file) => {'path':file.path,'size':file.size.toString()}).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
  static Future<List<PlatformFile>> fetchMedia({bool allowMultiple = false}) async {
    try {
      FilePicker filePicker = FilePicker.platform;
      FilePickerResult? result = await filePicker.pickFiles(
        type: FileType.custom,
        allowCompression: true,

        allowMultiple: allowMultiple,
        allowedExtensions: ['mp4','mov', 'jpg','jpeg','png'],

      );
      if (result != null) {
        return result.files;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

}



class CustomSnackBar {
  final BuildContext context;

  CustomSnackBar({required this.context});

  CustomSnackBar.show(
    this.context, {
    required String message,
    Function? action,
    String? actionMessage,
    Color? backgroundColor,
  }) {
    final snackBar = SnackBar(
      action: action == null
          ? null
          : SnackBarAction(
              label: actionMessage ?? "OK",
              onPressed: () => action,
              textColor: Colors.white54,
            ),
      backgroundColor: backgroundColor ?? backgroundColor ?? Colors.black,
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  CustomSnackBar.showError(
    this.context, {
    required String message,
    Function? action,
    String? actionMessage,
    Color? backgroundColor,
  }) {
    final snackBar = SnackBar(
      action: action == null
          ? null
          : SnackBarAction(
              label: actionMessage ?? "OK",
              onPressed: () => action,
              textColor: Colors.white54,
            ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: backgroundColor ?? backgroundColor ?? Colors.red,
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
