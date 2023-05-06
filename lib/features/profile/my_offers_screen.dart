import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyOffersScreen extends StatefulWidget {
  @override
  _MyOffersScreenState createState() => _MyOffersScreenState();
}

class _MyOffersScreenState extends State<MyOffersScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Offers'),
        ),
        body: Center(
          child: Text('You need to sign in to view your offers.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Offers'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('offers')
            .where('user_email', isEqualTo: user.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String productId = data['product_id'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('products')
                    .doc(productId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> productSnapshot) {
                  if (productSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (productSnapshot.hasError) {
                    return Text('Error fetching product details');
                  }

                  Map<String, dynamic> productData =
                      productSnapshot.data!.data() as Map<String, dynamic>;

                  return ListTile(
                    title: Text(productData['name']),
                    subtitle: Text(
                        'Kategori: ${productData['category']}\nTeklif: ${data['price']} TL\nAçıklama: ${data['description']}'),
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
