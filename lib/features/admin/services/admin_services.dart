import 'dart:convert';
import 'dart:io';
import 'package:amazon_clone/common/widgets/custom_dialog.dart';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/admin/model/sales.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminServices {
  Future<void> sellProducts({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    final provider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic('dohzacwq8', 'tamim24');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(response.secureUrl);
      }

      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: {
          // authorize
          'Content-Type': 'application/json; charset=UTF-8',
          'auth-token': provider.user.token,
        },
        body: product.toJson(), // sending the data
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          await CustomDialog.show(
            context,
            'Congrats!',
            'Product added successfully!',
          );
          Navigator.pop(context); // back to the main screen
        },
      );
    } catch (e) {
      CustomDialog.show(context, 'Selling Error', e.toString());
    }
  }

  // get all the products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false).user;
    List<Product> productList = [];

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-products'),
        headers: {
          // authorize
          'Content-Type': 'application/json; charset=UTF-8',
          'auth-token': userProvider.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(jsonEncode(jsonDecode(res.body)[i])),
            );
          }
        },
      );
    } catch (e) {
      CustomDialog.show(context, 'Fetching All Error', e.toString());
    }

    return productList;
  }

  // delete products
  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      http.Response res = await http.post(
        Uri.parse('$uri/admin/delete-product'),
        headers: {
          // authorize
          'Content-Type': 'application/json; charset=UTF-8',
          'auth-token': userProvider.user.token,
        },
        body: jsonEncode({'id': product.id}), // sending the data
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      CustomDialog.show(context, 'Deleting Product Error', e.toString());
    }
  }

  // fetch all orders
  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false).user;
    List<Order> orderList = [];

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-orders'),
        headers: {
          // authorize
          'Content-Type': 'application/json; charset=UTF-8',
          'auth-token': userProvider.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var decoded = jsonDecode(res.body);
          print('Decoded: $decoded');
          print('Type: ${decoded.runtimeType}');
          for (var item in decoded) {
            print('Item: $item, Type: ${item.runtimeType}');
            orderList.add(Order.fromMap(item as Map<String, dynamic>));
          }
        },
      );
    } catch (e) {
      CustomDialog.show(context, 'Fetching Order Error', e.toString());
    }

    return orderList;
  }

  // change order status
  // delete products
  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      http.Response res = await http.post(
        Uri.parse('$uri/admin/change-order-status'),
        headers: {
          // authorize
          'Content-Type': 'application/json; charset=UTF-8',
          'auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': order.id,
          'status': status,
        }), // sending the order id
      );

      httpErrorHandle(response: res, context: context, onSuccess: onSuccess);
    } catch (e) {
      CustomDialog.show(context, 'Change Order Status Error', e.toString());
    }
  }

  // fetch all orders
  Future<Map<String, dynamic>> getEarnigs(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false).user;
    List<Sales> sales = [];
    int totalEarning = 0;

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/analytics'),
        headers: {
          // authorize
          'Content-Type': 'application/json; charset=UTF-8',
          'auth-token': userProvider.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          totalEarning = response['totalEarnings'] ?? 0;
          sales = [
            Sales('Mobiles', response['mobileEarnings'] ?? 0),
            Sales('Essentials', response['essentialEarnings'] ?? 0),
            Sales('Books', response['bookEarnings'] ?? 0),
            Sales('Appliances', response['applianceEarnings'] ?? 0),
            Sales('Fashion', response['fashionEarnings'] ?? 0),
          ];
        },
      );
    } catch (e) {
      CustomDialog.show(context, 'Fetching Total Earning Error', e.toString());
    }

    return {'sales': sales, 'totalEarnings': totalEarning};
  }
}
