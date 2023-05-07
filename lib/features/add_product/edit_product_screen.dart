import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProductPage extends StatefulWidget {
  final String? productId;
  final String? productName;
  final String? category;
  final int? price;

  EditProductPage(
      {this.productId, this.productName, this.category, this.price});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _productName;
  String? _category;
  String? _price;

  @override
  void initState() {
    super.initState();
    _productName = widget.productName;
    _category = widget.category;
    _price = widget.price.toString();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Ürün verilerini Firestore'da güncelleme
      CollectionReference products =
          FirebaseFirestore.instance.collection('products');
      await products.doc(widget.productId).update({
        'name': _productName,
        'category': _category,
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
        title: Text('Ürün Düzenle'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange[300],
        elevation: 0, // Matlık için gerekli
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _productName,
                  decoration: InputDecoration(labelText: 'Ürün Adı'),
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
                TextFormField(
                  initialValue: _category,
                  decoration: InputDecoration(labelText: 'Kategori'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Lütfen bir kategori girin';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _category = value;
                  },
                ),
                TextFormField(
                  initialValue: _price,
                  decoration: InputDecoration(labelText: 'Fiyat (TL)'),
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
