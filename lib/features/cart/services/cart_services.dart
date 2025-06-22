import 'dart:convert';

import 'package:amazon_clone/common/widgets/custom_dialog.dart';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CartServices {
  void removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/remove-from-cart/${product.id}'), // using params
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'auth-token': userProvider.user.token,
        },
        body: jsonEncode({'id': product.id!}),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user = userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
          // User user = User.fromJson(jsonDecode(res.body));
          // userProvider.setUserFromModel(user);

          // CustomDialog.show(
          //   context,
          //   'WOW!!',
          //   'Product has been added to your cart!',
          // );
        },
      );
    } catch (e) {
      CustomDialog.show(context, 'Remove fron cart error!', e.toString());
    }
  }
}
