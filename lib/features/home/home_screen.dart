import 'package:flutter/material.dart';
import 'package:lego_market_app/features/info/food_advice_screen.dart';
import 'package:lego_market_app/features/orders/market_screen.dart';
import 'package:lego_market_app/features/profile/profile_screen.dart';
import 'package:lego_market_app/features/info/recyle_screen.dart';

class NavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hoş Geldiniz'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange[300],
        elevation: 0, // Matlık için gerekli
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _buildNavigationButton(
                  context,
                  'Market',
                  'assets/images/market_image.png',
                  MarketPage(),
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: _buildNavigationButton(
                  context,
                  'Profile',
                  'assets/images/profile_image.png',
                  Profile(),
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: _buildNavigationButton(
                  context,
                  'Info',
                  'assets/images/info_image.png',
                  VeggieListPage(),
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: _buildNavigationButton(
                  context,
                  'Food Advice',
                  'assets/images/food_advice_image.png',
                  FoodListPage(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
    BuildContext context,
    String title,
    String imagePath,
    Widget destination,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Color.fromARGB(255, 15, 230, 80),
            width: 3,
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => destination,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            shadowColor: Color.fromARGB(0, 209, 187, 187),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.all(0.0),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
