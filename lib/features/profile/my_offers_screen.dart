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
          centerTitle: true,
          backgroundColor: Colors.deepOrange[300],
          elevation: 0, // Matlık için gerekli
        ),
        body: Center(
          child: Text('You need to sign in to view your offers.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Offers'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange[300],
        elevation: 0, // Matlık için gerekli
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

                  return Dismissible(
                    key: Key(document.id),
                    onDismissed: (direction) {
                      FirebaseFirestore.instance
                          .collection('offers')
                          .doc(document.id)
                          .delete()
                          .then((value) => print('Offer deleted'))
                          .catchError((error) =>
                              print('Failed to delete offer: $error'));
                    },
                    child: ListTile(
                      title: Text(productData['name']),
                      subtitle: Text(
                          'Kategori: ${productData['category']}\nTeklif: ${data['price']} TL\nAçıklama: ${data['description']}'),
                    ),
                    background: Container(
                      color: Colors.red,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
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
