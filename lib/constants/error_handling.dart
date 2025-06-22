import 'dart:convert';
import 'package:amazon_clone/common/widgets/custom_dialog.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
    case 500:
    default:
      CustomDialog.show(context, "Error", (response.body));
  }
}
