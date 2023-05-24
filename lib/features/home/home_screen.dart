import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lego_market_app/features/info/news_screen.dart';
import 'package:lego_market_app/features/orders/market_screen.dart';
import 'package:lego_market_app/features/profile/profile_screen.dart';
import 'package:lego_market_app/features/info/decision_screen.dart';

class NavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    child: Image.asset(
                      'assets/images/splash2.png', //Replace with your logo asset path
                      height: 200,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
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
                  'Farm Academy',
                  'assets/images/farm_academy_image.png',
                  NewsPage(),
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
            color: Color.fromARGB(255, 175, 176, 177),
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
              Flexible(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      title,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
