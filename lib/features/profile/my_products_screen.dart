import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../add_product/edit_product_screen.dart';

class ProductListPage extends StatelessWidget {
  Widget buildProductItem(
      BuildContext context, DocumentSnapshot<Map<String, dynamic>> product) {
    return ExpansionTile(
      title: Text(product['name']),
      children: [
        Text('Fiyat: ${product['price']} TL'),
        SizedBox(height: 8),
        Text('Açıklama: ${product['description']}'),
        SizedBox(height: 8),
        Text('Teklifler:', style: TextStyle(fontWeight: FontWeight.bold)),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('offers')
              .where('product_id', isEqualTo: product.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Bir hata oluştu');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            final offers = snapshot.data!.docs;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];

                return ListTile(
                  title: Text('Teklif: ${offer['price']} TL'),
                  subtitle: Text('Açıklama: ${offer['description']}'),
                );
              },
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProductPage(
                  productId: product.id,
                  productName: product['name'],
                  category: product['category'],
                  price: product['price'],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    return Scaffold(
      appBar: AppBar(
        title: Text('Ürünlerim'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: products.snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Text('Bir hata oluştu');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot<Map<String, dynamic>> document) {
              return buildProductItem(context, document);
            }).toList(),
          );
        },
      ),
    );
  }
}
