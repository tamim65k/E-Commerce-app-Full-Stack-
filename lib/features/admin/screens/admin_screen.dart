import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/admin/screens/analytics_screen.dart';
import 'package:amazon_clone/features/admin/screens/orders_screen.dart';
import 'package:amazon_clone/features/admin/screens/post_screen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _currentIndex = 0;
  final double bottomBarWidth = 42;
  final double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const PostScreen(),
    const AnalyticsScreen(),
    const OrdersScreen(), // Placeholder for Cart Page
  ];

  void updatePage(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Image.asset(
                  'assets/images/amazon_in.png',
                  width: 120,
                  height: 45,
                  color: Colors.black,
                ),
              ),
              const Text(
                'Admin Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
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
              decoration: BoxDecoration(
                border: Border(
                  // top: BorderSide(
                  //   width: bottomBarBorderWidth,
                  //   color:
                  //       _currentIndex == 0
                  //           ? GlobalVariables.selectedNavBarColor
                  //           : GlobalVariables.backgroundColor,
                  // ),
                ),
              ),
              child: Icon(Icons.home_outlined),
            ),
          ),
          BottomNavigationBarItem(
            label: "Analytics",
            icon: Container(
              alignment: Alignment.center,

              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  // top: BorderSide(
                  //   width: bottomBarBorderWidth,
                  //   color:
                  //       _currentIndex == 1
                  //           ? GlobalVariables.selectedNavBarColor
                  //           : GlobalVariables.backgroundColor,
                  // ),
                ),
              ),
              child: Icon(Icons.analytics_outlined),
            ),
          ),

          BottomNavigationBarItem(
            label: "Orders",
            icon: Container(
              alignment: Alignment.center,

              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  // top: BorderSide(
                  //   width: bottomBarBorderWidth,
                  //   color:
                  //       _currentIndex == 0
                  //           ? GlobalVariables.selectedNavBarColor
                  //           : GlobalVariables.backgroundColor,
                  // ),
                ),
              ),
              child: Icon(Icons.all_inbox_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
