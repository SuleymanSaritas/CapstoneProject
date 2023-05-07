import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../orders/offers_screen.dart';

class MarketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    return Scaffold(
      appBar: AppBar(
        title: Text('Market'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange[300],
        elevation: 0, // Matlık için gerekli
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: products.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Bir hata oluştu');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('email', isEqualTo: data['email'])
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (userSnapshot.data?.docs.isEmpty ?? true) {
                    return ListTile(
                      title: Text('Kullanıcı verisi bulunamadı'),
                    );
                  }

                  return ListTile(
                    title: Text(data['name']),
                    subtitle: Text(
                        '${data['category']} - ${data['price']} TL - Satıcı: ${data['userNameSurname']}'),
                    trailing: ElevatedButton.icon(
                      icon: Icon(Icons.local_offer),
                      label: Text('Teklif Ver'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OfferScreen(
                              productId: data['product_id'],
                            ),
                          ),
                        );
                      },
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

class CreateOfferDialog extends StatefulWidget {
  final String productId;
  final String sellerId;

  CreateOfferDialog({required this.productId, required this.sellerId});

  @override
  _CreateOfferDialogState createState() => _CreateOfferDialogState();
}

class _CreateOfferDialogState extends State<CreateOfferDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _offerDetails = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Teklif Oluştur'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Teklif Detayları'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Lütfen teklif detaylarını girin';
            }
            return null;
          },
          onSaved: (value) {
            if (value != null) {
              _offerDetails = value;
            }
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('İptal'),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();

              await FirebaseFirestore.instance.collection('offers').add({
                'productId': widget.productId,
                'sellerId': widget.sellerId,
                // Alıcı olarak şu anki kullanıcıyı eklemek için 'userId' kullanın.
                // Kullanıcı kimliğini nasıl alacağınız projenize bağlıdır.
                '`FirebaseAuth.instance.currentUser.uid`': 'userId',
                'details': _offerDetails,
                'status': 'pending', // Teklifin başlangıç durumu
                'timestamp': FieldValue.serverTimestamp(),
              });

              Navigator.pop(context);
            }
          },
          child: Text('Teklif Gönder'),
        ),
      ],
    );
  }
}
