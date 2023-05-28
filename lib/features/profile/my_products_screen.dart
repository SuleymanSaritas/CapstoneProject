import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../add_product/edit_product_screen.dart';
import '../add_product/product_detail_screen.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String? _nameSurname;

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
  }

  Future<void> getCurrentUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
      setState(() {
        _nameSurname = data['email'];
      });
    }
  }

  Widget buildProductItem(BuildContext context, DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return ListTile(
      title: Text(data['name']),
      subtitle: Text('${data['quantity']} - ${data['price']} TL'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductPage(
                    productId: document.id,
                    productName: data['name'],
                    productQuantity: data['quantity'],
                    price: data['price'],
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Delete Product'),
                    content:
                        Text('Are you sure you want to delete this product?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('products')
                              .doc(document.id)
                              .delete();
                          Navigator.pop(context);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(
                    productId: document.id,
                    price: data['price'],
                    productName: data['name'],
                    productQuantity: data['quantity'],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_nameSurname == null) {
      return Scaffold(
        appBar: AppBar(title: Text('My Products')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: products
            .where('userNameSurname', isEqualTo: _nameSurname)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Bir hata oluştu');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return buildProductItem(context, document);
            }).toList(),
          );
        },
      ),
    );
  }
}
