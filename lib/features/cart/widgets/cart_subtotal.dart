import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    for (var item in user.cart) {
      final quantity = int.tryParse(item['quantity']?.toString() ?? '0') ?? 0;
      final product = item['product'];
      int price = 0;
      if (product is Map && product['price'] != null) {
        price = int.tryParse(product['price'].toString()) ?? 0;
      }
      sum += quantity * price;
    }

    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("Subtotal ", style: TextStyle(fontSize: 20)),
          Text(
            '\$${sum}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
