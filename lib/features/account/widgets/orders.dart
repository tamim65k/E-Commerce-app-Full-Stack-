import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/account/services/account_services.dart';
import 'package:amazon_clone/features/account/widgets/single_product.dart';
import 'package:amazon_clone/features/order_details/screens/order_details_screen.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  // List list = [
  //   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJ2iikTiSrG0Cq--mXPKX1S9Acwm0X3Kc9jg&s',
  //   'https://images.unsplash.com/photo-1594007759138-855170ec8dc0?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bmFydXRvJTIwdXp1bWFraXxlbnwwfHwwfHx8MA%3D%3D',
  //   'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bWFjYm9va3xlbnwwfHwwfHx8MA%3D%3D',
  // ];

  List<Order>? orders;
  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await accountServices.fetchMyOrder(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    child: Text(
                      'Your orders',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Container(
                    child: Text(
                      'See all',
                      style: TextStyle(
                        // fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: GlobalVariables.selectedNavBarColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // display orders
            SizedBox(height: 10),
            Container(
              height: 170,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final order = orders![index];
                  if (order.products.isEmpty) {
                    return const SizedBox(); // or show a placeholder
                  }
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        OrderDetailsScreen.routeName,
                        arguments: order,
                      );
                    },
                    child: SingleProduct(image: order.products[0].images[0]),
                  );
                },
                itemCount: orders!.length,
              ),
            ),
          ],
        );
  }
}
