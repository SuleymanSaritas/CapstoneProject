import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProductPage extends StatefulWidget {
  final String? productId;
  final String? productName;
  final int? productQuantity;
  final int? price;

  EditProductPage({
    this.productId,
    this.productName,
    this.productQuantity,
    this.price,
  });

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _productName;
  int? _productQuantity;
  String? _price;

  @override
  void initState() {
    super.initState();
    _productName = widget.productName;
    _productQuantity = widget.productQuantity;
    _price = widget.price.toString();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Ürün verilerini Firestore'da güncelleme
      CollectionReference products =
          FirebaseFirestore.instance.collection('products');
      await products.doc(widget.productId).update({
        'productName': _productName,
        'productQuantity': _productQuantity,
        'price': int.parse(_price as String),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ürün başarıyla güncellendi')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        centerTitle: true,
        backgroundColor: Color(0xFF8A2BE2),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Ürün Adı',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    initialValue: _productName,
                    decoration: InputDecoration(
                      labelText: 'Ürün Adı',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lütfen bir ürün adı girin';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _productName = value;
                    },
                  ),
                ),
                Text(
                  'Ürün Miktarı',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    initialValue: _productQuantity.toString(),
                    decoration: InputDecoration(
                      labelText: 'Ürün Miktarı',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lütfen bir ürün miktarı girin';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _productQuantity = int.parse(value as String);
                    },
                  ),
                ),
                Text(
                  'Fiyat',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    initialValue: _price,
                    decoration: InputDecoration(
                      labelText: 'Fiyat (TL)',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lütfen bir fiyat girin';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _price = value;
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Ürünü Güncelle'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
