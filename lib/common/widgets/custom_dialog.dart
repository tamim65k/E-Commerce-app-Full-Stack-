import 'package:flutter/material.dart';

class CustomDialog {
  static Future<void> show(
    BuildContext context, [
    String? title,
    String? message,
    Color? titleColor,
    Color? messageColor,
  ]) {
    // Ensure that at least a title or a message is provided.
    assert(title != null || message != null, 'Cannot show a dialog with no title or message.');

    return showDialog(
      useRootNavigator: true,
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(4, 4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: const Offset(-4, -4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: titleColor ?? Colors.black,
                      ),
                    ),
                  if (title != null && message != null)
                    const SizedBox(height: 10),
                  if (message != null)
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 16,
                        color: messageColor ?? Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}