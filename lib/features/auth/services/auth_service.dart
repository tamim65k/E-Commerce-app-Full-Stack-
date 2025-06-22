import 'dart:convert';
import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/common/widgets/custom_dialog.dart';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //sign up user
  void signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        password: password,
        email: email,
        address: '',
        type: '',
        token: '',
        cart: [],
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          CustomDialog.show(
            context,
            "Account Created",
            "Your account has been created successfully. Please log in.",
          );
        },
      );
    } catch (e) {
      // showSnackbar(context, e.toString());
      CustomDialog.show(context, 'Sing-up Errror', e.toString());
    }
  }

  // sign in user
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          final userJson = jsonDecode(res.body);
          User user = User.fromMap(userJson); // changed
          Provider.of<UserProvider>(context, listen: false).setUser(user);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("auth-token", jsonDecode(res.body)['token']);

          // Inside your signInUser onSuccess callback
          await CustomDialog.show(
            context,
            "Welcome",
            "You have successfully logged in.",
          );
          if (!context.mounted)
            return; // Ensure the context is still valid before navigating
          Navigator.pushNamedAndRemoveUntil(
            context,
            BottomBar.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      // showSnackbar(context, e.toString());
      CustomDialog.show(context, 'Sing-In Errror', e.toString());
    }
  }

  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth-token');
      // print('Loaded token: $token');

      if (token == null) {
        await prefs.setString('auth-token', '');
        token = '';
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'auth-token': token!,
        },
      );

      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'auth-token': token,
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        User user = User.fromMap(jsonDecode(userRes.body));
        userProvider.setUser(user);
      }
    } catch (e) {
      CustomDialog.show(context, 'Get user data error', e.toString());
    }
  }
}
