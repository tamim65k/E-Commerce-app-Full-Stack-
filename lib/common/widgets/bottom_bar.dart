import 'package:amazon_clone/common/widgets/test_dialog.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/account/screens/account_screen.dart';
import 'package:amazon_clone/features/cart/screens/cart_screen.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class BottomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;
  final double bottomBarWidth = 42;
  final double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen(), 
    // const DialogTestPage(),
  ];

  void updatePage(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCartLen = context.watch<UserProvider>().user.cart.length;

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: updatePage,
        currentIndex: _currentIndex,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        iconSize: 28,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Container(
              alignment: Alignment.center,

              width: bottomBarWidth,

              child: Icon(Icons.home_outlined),
            ),
          ),
          BottomNavigationBarItem(
            label: "Account",
            icon: Container(
              alignment: Alignment.center,

              width: bottomBarWidth,

              child: Icon(Icons.person_2_outlined),
            ),
          ),
          BottomNavigationBarItem(
            label: "Cart",
            icon: Container(
              alignment: Alignment.center,
              width: bottomBarWidth,

              child: badges.Badge(
                badgeContent: Text(
                  '${userCartLen}',
                  style: TextStyle(
                    color: Colors.white, // Set text color for visibility
                  ),
                ),
                child: Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
