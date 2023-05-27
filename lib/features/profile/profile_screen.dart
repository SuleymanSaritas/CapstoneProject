import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lego_market_app/core/components/navigator/pop.dart';
import 'package:lego_market_app/core/components/navigator/push.dart';

import '../../authenticate/auth_page/auth_type_selector.dart';
import '../add_product/add_product_screen.dart';
import '../home/home_screen.dart';
import '../profile/my_products_screen.dart';
import 'my_benefit_history.dart';
import 'my_offers_screen.dart';
// import 'profile_build_data.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _ProfileState extends State<Profile> {
  late Stream<DocumentSnapshot> _usersStream;
  final Color backgroundColor = Color(0xFFECECEC);
  final Color redColor = Colors.red;
  final Color greenColor = Colors.green;
  final Color whiteColor = Colors.white;
  final Color blackColor = Colors.black;

  final Color transparentColor = Colors.blue;
  final Color darkerOrangeColor = Colors.deepOrange[700] ?? Colors.deepOrange;

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser != null) {
      _usersStream = FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid.toString())
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser == null) {
      return AuthTypeSelector();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Image.asset(
                  'assets/images/your_image.png'), // <-- Change 'assets/your_image.png' with your image path
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: StreamBuilder<DocumentSnapshot>(
                stream: _usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  final Map<String, dynamic>? userData =
                      snapshot.data?.data() as Map<String, dynamic>?;

                  return Column(
                    children: [
                      buildProfileData(
                          "Name Surname", userData?['name surname'] ?? ''),
                      buildProfileData("Email", userData?['email'] ?? ''),
                      buildProfileData("Phone", userData?['phone'] ?? ''),
                      buildProfileData("Address", userData?['address'] ?? ''),
                    ],
                  );
                },
              ),
            ),
            Divider(height: 40, color: Colors.grey),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  addProductButton(),
                  myOffersButton(),
                  myProductsButton(),
                  myBenefitHistoryButton(),
                  logoutButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileData(String title, String data) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context)
            .cardColor, // cardColor genellikle beyaz (light mode) ya da gri (dark mode) olacaktır.
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.color, // Metin rengini mevcut temanın bodyText1 rengine göre ayarlıyoruz.
            ),
          ),
          Expanded(
            child: Text(
              data,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color, // Metin rengini mevcut temanın bodyText1 rengine göre ayarlıyoruz.
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding addProductButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: ElevatedButton(
        onPressed: () {
          navigatorPush(
            context,
            AddProductPage(),
          );
        },
        child: ListTile(
          leading: Icon(
            Icons.add_box,
            size: 20, // İkon boyutunu küçült
            color: whiteColor,
          ),
          title: Text(
            "Add Product",
            style: TextStyle(
              fontSize: 16, // Yazı boyutunu küçült
              color: whiteColor,
            ),
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            greenColor,
          ),
        ),
      ),
    );
  }

  Padding myOffersButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: ElevatedButton(
        onPressed: () {
          navigatorPush(
            context,
            MyOffersScreen(),
          );
        },
        child: ListTile(
          leading: Icon(
            Icons.local_offer,
            size: 20, // İkon boyutunu küçült
            color: whiteColor,
          ),
          title: Text(
            "My Offers",
            style: TextStyle(
              fontSize: 16, // Yazı boyutunu küçült
              color: whiteColor,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            greenColor,
          ),
        ),
      ),
    );
  }

  Padding myProductsButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: ElevatedButton(
        onPressed: () {
          navigatorPush(
            context,
            ProductListPage(),
          );
        },
        child: ListTile(
          leading: Icon(
            Icons.shopping_bag,
            size: 20, // İkon boyutunu küçült
            color: whiteColor,
          ),
          title: Text(
            "My Products",
            style: TextStyle(
              fontSize: 16, // Yazı boyutunu küçült
              color: whiteColor,
            ),
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            greenColor,
          ),
        ),
      ),
    );
  }

  Padding logoutButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: ElevatedButton(
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Are you sure you want to log out?"),
              content: Icon(
                Icons.warning,
                size: 30, // İkon boyutunu küçült
                color: redColor,
              ),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NavigationPage(),
                      ),
                    );
                  },
                  child: Text('LOG OUT'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      redColor,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => navigatorPop(context),
                  child: Text('CANCEL'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      greenColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        child: ListTile(
          leading: Icon(
            Icons.logout,
            size: 20, // İkon boyutunu küçült
            color: whiteColor,
          ),
          title: Text(
            "Log out",
            style: TextStyle(
              fontSize: 16, // Yazı boyutunu küçült
              color: whiteColor,
            ),
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            redColor,
          ),
        ),
      ),
    );
  }

  Padding myBenefitHistoryButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: ElevatedButton(
        onPressed: () {
          navigatorPush(
            context,
            BenefitHistoryPage(),
          );
        },
        child: ListTile(
          leading: Icon(
            Icons.history,
            size: 20, // İkon boyutunu küçült
            color: whiteColor,
          ),
          title: Text(
            "My Benefit History",
            style: TextStyle(
              fontSize: 16, // Yazı boyutunu küçült
              color: whiteColor,
            ),
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            darkerOrangeColor,
          ),
        ),
      ),
    );
  }

  Padding accountIconExtMeth() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        3,
        1,
        20,
        1,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10,
          ),
          color: transparentColor,
        ),
        child: Icon(
          Icons.account_circle_rounded,
          size: 70, // İkon boyutunu küçült
          color: whiteColor,
        ),
      ),
    );
  }

  Center circularProgressExtMeth() {
    return Center(
      child: CircularProgressIndicator(
        color: redColor,
      ),
    );
  }

  // AppBar mainAppBarExt() {
  //   return AppBar(
  //     title: Text(
  //       "Profile",
  //       style: TextStyle(
  //         fontSize: 20, // Yazı boyutunu küçült
  //         fontFamily: 'Roboto',
  //       ),
  //     ),
  //     centerTitle: true,
  //     backgroundColor: darkerOrangeColor,
  //     elevation: 0,
  //     automaticallyImplyLeading: false,
  //     leading: CustomBackButton(),
  //   );
  // }
}
