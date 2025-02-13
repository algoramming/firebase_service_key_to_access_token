import 'context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

final globalSnackbarKey = GlobalKey<ScaffoldMessengerState>();

class KSnackbar {
  static hideSnackBar(BuildContext context) =>
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

  static show(
    BuildContext context,
    String content, {
    int? second,
    TextStyle? contentTextStyle,
    bool isError = false,
  }) {
    if (EasyLoading.isShow) EasyLoading.dismiss();
    hideSnackBar(context);
    second ??= (isError ? 5 : 3);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: _Content(
          content: content,
          second: second,
          contentTextStyle: contentTextStyle,
          isError: isError,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        duration: Duration(seconds: second),
        animation: const AlwaysStoppedAnimation(1.0),
        padding: const EdgeInsets.all(0.0),
        margin: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 20.0),
        showCloseIcon: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    /// Main body message
    required this.content,

    /// default time set 4 seconds.
    required this.second,

    /// default TextStyle is none.
    this.contentTextStyle,

    /// default is false.
    /// if true, the snackbar will be red.
    /// if false, the snackbar will be black.
    this.isError = false,
  });

  final String content;
  final int second;
  final TextStyle? contentTextStyle;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (context.isScreenDesktop)
          const Expanded(flex: 2, child: SizedBox.shrink()),
        Expanded(
          flex: context.isScreenDesktop ? 3 : 1,
          child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            color: isError ? Colors.red : Theme.of(context).textTheme.bodyLarge?.color,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxHeight: 27.0),
                    child: TweenAnimationBuilder(
                      tween: Tween<double>(
                        begin: 0,
                        end: second * 1000.toDouble(),
                      ),
                      duration: Duration(seconds: second),
                      builder: (context, double value, child) {
                        return Stack(
                          fit: StackFit.loose,
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 25.0,
                              width: 25.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                value: value / (second * 1000),
                                color:
                                    isError
                                        ? Colors.white
                                        : Theme.of(context).cardColor,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            Center(
                              child: Text(
                                (second - (value / 1000)).toInt().toString(),
                                textScaler: const TextScaler.linear(0.85),
                                style:
                                    contentTextStyle ??
                                    Theme.of(
                                      context,
                                    ).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color:
                                          isError
                                              ? Colors.white
                                              : Theme.of(
                                                context,
                                              ).cardColor,
                                    ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      content,
                      style:
                          contentTextStyle ??
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            color:
                                isError
                                    ? Colors.white
                                    : Theme.of(
                                      context,
                                    ).cardColor,
                          ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  InkWell(
                    borderRadius: BorderRadius.circular(45),
                    onTap:
                        () =>
                            ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                    child: Icon(
                      Icons.close,
                      size: 20.0,
                      color: isError ? Colors.white : Theme.of(context).cardColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (context.isScreenDesktop)
          const Expanded(flex: 2, child: SizedBox.shrink()),
      ],
    );
  }
}
