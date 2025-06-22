import 'dart:convert';
import 'package:amazon_clone/common/widgets/custom_dialog.dart';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountServices {
  // a get request for fetch all the orders
  Future<List<Order>> fetchMyOrder({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false).user;
    List<Order> orderList = [];

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/orders/me'),
        headers: {
          // authorization
          'Content-Type': 'application/json; charset=UTF-8',
          'auth-token': userProvider.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (var order in jsonDecode(res.body)) {
            orderList.add(Order.fromMap(order));
          }
        },
      );
    } catch (e) {
      CustomDialog.show(context, 'Fetching Order Error', e.toString());
    }

    return orderList;
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('auth-token', '');
      Navigator.pushNamedAndRemoveUntil(// pop all other screens
        context,
        AuthScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      CustomDialog.show(context, 'Logout Successfull!');
    }
  }
}
