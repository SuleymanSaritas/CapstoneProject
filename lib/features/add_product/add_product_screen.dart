import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lego_market_app/product/products/products.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _productName;
  String? _category;
  String? _price;
  String? _name_Surname;
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
        _name_Surname = data['name surname'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Ürün Ekleme Sayfası'),
      //   centerTitle: true,
      //   backgroundColor: Colors.deepOrange[300],
      //   elevation: 0, // Matlık için gerekli
      // ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Ürün Adı',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen ürün adını girin';
                  }
                  return null;
                },
                onSaved: (value) => _productName = value,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: ['Meyve', 'Sebze']
                    .map((category) => DropdownMenuItem(
                          child: Text(category),
                          value: category,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Lütfen bir kategori seçin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Fiyat',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Lütfen ürün fiyatını girin';
                  }
                  return null;
                },
                onSaved: (value) => _price = value,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Ürün Ekle'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Ürün verilerini Firestore'a kaydetme
      CollectionReference products =
          FirebaseFirestore.instance.collection('products');
      String productId = products.doc().id;
      Product product = Product(
        product_id: productId,
        name: _productName!,
        category: _category!,
        price: int.parse(_price!),
        userNameSurname: _name_Surname!,
      );
      await products.doc(productId).set({
        'product_id': product.product_id,
        'name': product.name,
        'category': product.category,
        'price': product.price,
        'userNameSurname': _name_Surname!,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ürün başarıyla eklendi')),
      );
      Navigator.pop(context);
    }
  }
}
