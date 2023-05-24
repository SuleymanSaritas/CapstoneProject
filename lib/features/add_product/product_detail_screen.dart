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
      backgroundColor: Color(0xFFF0EAD6),
      appBar: AppBar(
        title: Text('Product Details'),
        centerTitle: true,
        backgroundColor: Color(0xFF8A2BE2),
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: products.doc(productId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Bir hata oluştu');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final Map<String, dynamic>? data =
              snapshot.data?.data() as Map<String, dynamic>?;

          if (data == null) {
            return Text('Ürün bulunamadı');
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
                  'Miktar: $productQuantity',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Fiyat: $price TL',
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
                      return Text('Bir hata oluştu');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final offers = snapshot.data!.docs;

                    if (offers.isEmpty) {
                      return Center(
                        child: Text('Bu ürüne henüz bir teklif yapılmamış.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: offers.length,
                      itemBuilder: (context, index) {
                        final offer = offers[index];

                        return ListTile(
                          title: Text('Teklif: ${offer['price']} TL'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Quantity: ${offer['quantity']} kg'),
                              Text('Bidder: ${offer['user_email']}'),
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
