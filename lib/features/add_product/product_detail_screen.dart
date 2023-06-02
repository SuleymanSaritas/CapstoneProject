import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final String? productId;
  final String? productName;
  final int? productQuantity;
  final int? price;

  ProductDetailPage({
    required this.productId,
    required this.productName,
    required this.productQuantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: products.doc(productId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final Map<String, dynamic>? data =
              snapshot.data?.data() as Map<String, dynamic>?;

          if (data == null) {
            return Text('Product not found');
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  productName!,
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Quantity: $productQuantity',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Price (per kg) : $price TL',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              SizedBox(height: 24.0),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('offers')
                      .where('product_id', isEqualTo: productId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final offers = snapshot.data!.docs;

                    if (offers.isEmpty) {
                      return Center(
                        child: Text(
                            'No offers have been made for this product yet.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: offers.length,
                      itemBuilder: (context, index) {
                        final offer = offers[index];

                        return ListTile(
                          title: Text('Offer: ${offer['price']} TL'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Quantity: ${offer['quantity']} kg'),
                              Text('Bidder: ${offer['user_email']}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check_circle,
                                    color: Colors.green),
                                onPressed: () async {
                                  final offerQuantity = offer['quantity'];
                                  final newProductQuantity =
                                      productQuantity! - offerQuantity;

                                  if (newProductQuantity <= 0) {
                                    await products.doc(productId).delete();
                                  } else {
                                    await products.doc(productId).update({
                                      'quantity': newProductQuantity,
                                    });
                                  }

                                  // Delete the accepted offer.
                                  await FirebaseFirestore.instance
                                      .collection('offers')
                                      .doc(offer.id)
                                      .delete();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.cancel, color: Colors.red),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('offers')
                                      .doc(offer.id)
                                      .delete();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
