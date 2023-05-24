import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OfferScreen extends StatefulWidget {
  final String productId;
  final String userEmail;

  OfferScreen({required this.productId})
      : userEmail = FirebaseAuth.instance.currentUser!.email!;

  @override
  _OfferScreenState createState() => _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _offerPrice;
  String? _offerQuantity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teklif Verme Sayfası'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Teklif Fiyatı',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Lütfen teklif fiyatını girin';
                    }
                    return null;
                  },
                  onSaved: (value) => _offerPrice = value,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Miktar',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Lütfen bir miktar girin';
                    }
                    return null;
                  },
                  onSaved: (value) => _offerQuantity = value,
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Teklif Ver'),
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

      // Teklif verilerini Firestore'a kaydetme
      CollectionReference offers =
          FirebaseFirestore.instance.collection('offers');
      await offers.add({
        'product_id': widget.productId,
        'price': int.parse(_offerPrice as String),
        'quantity': int.parse(_offerQuantity as String),
        'user_email': widget.userEmail,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Teklif başarıyla gönderildi')),
      );
      Navigator.pop(context);
    }
  }
}
