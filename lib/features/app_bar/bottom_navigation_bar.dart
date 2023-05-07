import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lego_market_app/core/components/icon/bottom_icon.dart';
import 'package:lego_market_app/features/home/home_screen.dart';
import 'package:lego_market_app/features/info/food_advice_screen.dart';
import 'package:lego_market_app/features/orders/null_user_order.dart';
import 'package:lego_market_app/features/orders/market_screen.dart';
import 'package:lego_market_app/features/profile/profile_screen.dart';
import 'package:lego_market_app/features/info/recyle_screen.dart';

import '../../../authenticate/auth_page/auth_type_selector.dart';

class BottomHomePage extends StatefulWidget {
  @override
  _BottomHomePageState createState() => _BottomHomePageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _BottomHomePageState extends State<BottomHomePage> {
  final Color myBackgroundColor = Color(0xF5380025);
  int _selectedIndex = 0;
  final tabs = [
    HomePage(),
    _auth.currentUser == null ? NullUserOrders() : MarketPage(),
    _auth.currentUser == null ? AuthTypeSelector() : Profile(),
    _auth.currentUser == null ? AuthTypeSelector() : VeggieListPage(),
    _auth.currentUser == null ? AuthTypeSelector() : FoodListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigationBar(),
      body: tabs[_selectedIndex],
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      unselectedItemColor: Colors.grey.shade400,
      items: [
        BottomNavigationBarItem(
          icon: buildBottomIcon(
            Icons.home,
          ),
          label: "HOME",
          backgroundColor: myBackgroundColor,
        ),
        BottomNavigationBarItem(
          icon: buildBottomIcon(
            Icons.shopping_cart,
          ),
          label: "MARKET",
          backgroundColor: myBackgroundColor,
        ),
        BottomNavigationBarItem(
          icon: buildBottomIcon(
            Icons.account_circle_rounded,
          ),
          label: "PROFILE",
          backgroundColor: myBackgroundColor,
        ),
        BottomNavigationBarItem(
          icon: buildBottomIcon(
            Icons.help,
          ),
          label: "INFO",
          backgroundColor: myBackgroundColor,
        ),
        BottomNavigationBarItem(
          icon: buildBottomIcon(
            Icons.food_bank_sharp,
          ),
          label: "FOOD ADVICE",
          backgroundColor: myBackgroundColor,
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: onItemTapped,
      type: BottomNavigationBarType.shifting,
    );
  }

  void onItemTapped(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }
}
