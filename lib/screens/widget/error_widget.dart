import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppPromptWidget extends StatelessWidget {
  final String? message;
  final String? title;
  final VoidCallback? onTap;
  final String? imagePath;
  final bool? isSvgResource;
  final bool? canTryAgain;

  const AppPromptWidget({
    Key? key,
    this.message = 'Ooops an error occured',
    this.title,
    this.onTap,
    this.imagePath,
    this.isSvgResource = false,
    this.canTryAgain = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isSvgResource!
              ? SvgPicture.asset(
                  imagePath ?? 'assets/svgs/server_error.svg',
                  width: 150,
                )
              : Image.asset(
                  imagePath ?? 'assets/pngs/sorry.png',
                  height: 150,
                ),
          if (title != null)
            Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          if (message != null)
            Column(
              children: [
                Text(
                  message!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          if (canTryAgain!)
            Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                OutlinedButton(
                    onPressed: onTap,
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                    child: const Text("Try again")),
              ],
            )
        ],
      )),
    );
  }
}
