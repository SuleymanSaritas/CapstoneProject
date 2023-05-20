import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lego_market_app/core/components/navigator/pop.dart';
import 'package:lego_market_app/core/components/navigator/push.dart';

import '../../../core/components/row/profile_row.dart';
import '../../../core/widget/color.dart';
import '../../../core/widget/gradient_container.dart';
import '../../authenticate/auth_page/auth_type_selector.dart';
import '../add_product/add_product_screen.dart';
import '../home/home_screen.dart';
import '../orders/custombackbutton.dart';
import '../profile/my_products_screen.dart';
import 'my_offers_screen.dart';
import 'profile_build_data.dart';

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
      backgroundColor: backgroundColor,
      appBar: mainAppBarExt(),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return circularProgressExtMeth();
          }

          final Map<String, dynamic>? userData = snapshot.data?.data() as Map<String, dynamic>?;

          return ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildProfileData(
                    whiteColor
                ,
                    80,
                    120,
                    Alignment.center,
                    Row(
                      children: [
                        accountIconExtMeth(),
                        Text(
                          userData?['name surname'] ?? '',
                          style: TextStyle(
                            fontSize: 23,
                            color: blackColor
                        ,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildProfileData(
                    whiteColor
                ,
                    80,
                    60,
                    Alignment.centerLeft,
                    buildProfileRow(
                      userData?['email'] ?? '',
                      Icons.mail,
                    ),
                  ),
                  buildProfileData(
                    whiteColor
                ,
                    80,
                    60,
                    Alignment.centerLeft,
                    buildProfileRow(
                      userData?['phone'] ?? '',
                      Icons.phone,
                    ),
                  ),
                  buildProfileData(
                    whiteColor
                ,
                    80,
                    60,
                    Alignment.centerLeft,
                    buildProfileRow(
                      userData?['address'] ?? '',
                      Icons.home,
                    ),
                  ),
                  myOffersButton(),
                  addProductButton(),
                  myProductsButton(),
                  logoutButton(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildProfileRow(String data, IconData icon) {
  return Row(
    children: [
      Icon(
        icon,
        size: 20,
        color: whiteColor,
      ),
      SizedBox(width: 10),
      Text(
        data,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black, 
        ),
      ),
    ],
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
            size: 27,
            color: whiteColor
        ,
          ),
          title: Text(
            "Add Product",
            style: TextStyle(
              fontSize: 20,
              color: whiteColor
          ,
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
            size: 27,
            color: whiteColor
        ,
          ),
          title: Text(
            "My Offers",
            style: TextStyle(
              fontSize: 20,
              color: whiteColor
          ,
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
            size: 27,
            color: whiteColor
        ,
          ),
          title: Text(
            "My Products",
            style: TextStyle(
              fontSize: 20,
              color: whiteColor
          ,
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
                size: 40,
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
            size: 27,
            color: whiteColor
        ,
          ),
          title: Text(
            "Log out",
            style: TextStyle(
              fontSize: 20,
              color: whiteColor
          ,
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
          size: 110,
          color: whiteColor
      ,
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

  AppBar mainAppBarExt() {
    return AppBar(
      title: Text(
        "Profile",
        style: TextStyle(
          fontSize: 24,
          fontFamily: 'Roboto',
        ),
      ),
      centerTitle: true,
      backgroundColor: darkerOrangeColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: CustomBackButton(),
    );
  }
}
