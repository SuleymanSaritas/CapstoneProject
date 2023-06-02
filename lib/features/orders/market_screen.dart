import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../orders/offers_screen.dart';

class MarketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    return Scaffold(
      appBar: AppBar(
        title: Text('Market'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: products.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('email', isEqualTo: data['email'])
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (userSnapshot.data?.docs.isEmpty ?? true) {
                    return ListTile(
                      title: Text('User data not found'),
                    );
                  }

                  final currentUser = FirebaseAuth.instance.currentUser;

                  return Card(
                    elevation: 5,
                    child: ListTile(
                      title: Text(
                        data['name'],
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        ' ${data['price']} TL - Seller: ${data['userNameSurname']}',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      trailing: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          textStyle: TextStyle(color: Colors.white),
                        ),
                        icon: Icon(Icons.local_offer),
                        label: Text('Give Offer'),
                        onPressed: () {
                          if (currentUser != null &&
                              data['userNameSurname'] != currentUser.email) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OfferScreen(
                                  productId: data['product_id'],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
