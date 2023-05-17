import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DonationPage extends StatefulWidget {
  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  String? _chosenVeggie;
  final TextEditingController weightController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _showBenefitDialog(double weight, int value) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text(
              'Your benefit to nature is ${weight * value}. Keep up the good work!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Options'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... Your previous widgets ...
              Text(
                'Food Banks to Donate Your Vegetables:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'The list of food banks is for when the vegetables are not needed:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('• iHH- insani yardim Vakfi'),
              Text('• Aip- Acil intiyas projesi Vakfi'),
              Text('• Insani insa dernegi'),
              Text('• Uluslararasi Insani Yardim Dernegi'),
              Text('• 1 Tek Lira Dernegi'),
              Text('• lyilikler Yardimlasma Dernegi'),
              Text('• Besir Dernegi'),
              Text('• Vuslat Dernegi'),
              Text('• Aziz Mahmud Hüdayi Vakfi'),
              Text('• Endes Engellilere Destek ve Yardim Dernegi'),
              Text(
                  '• TİDER (Basic Needs Association organization) (food bank umberlla org.)'),
              Text(
                  '• Donate to soup kitchens that aim to serve food to the homeless such as:'),
              InkWell(
                onTap: () {
                  // Handle the URL redirect here
                },
                child: Text(
                  '“Hayata Sarıl Lokantası” (Embrace Life Restaurant), a restaurant for homeless people in Istanbul',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Donations for Animal Feed:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'List of where you can donate food for animal feed:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text('Animal Shelter'),
              Text('1) Türkiye Hayvanları Koruma Derneği (Animal Shelter)'),
              Text('2) Haçiko (Animal Shelter)'),
              Text('3) Haytap (Animal Shelter)'),
              Text('4) Yedikule Hayvan Barınağı (Animal Shelter)'),
              InkWell(
                onTap: () {
                  // Handle the URL redirect here
                },
                child: Text(
                  '5) Special "bread dumpsters" located in Istanbul that recycle bread into animal feed',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    _firestore.collection('veggie_waste_solutions').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var veggieList = snapshot.data!.docs
                      .map((doc) => doc['name'])
                      .toList()
                      .cast<String>();

                  return Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Choose a Vegetable",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DropdownButton<String>(
                            value: _chosenVeggie,
                            items: veggieList.map<DropdownMenuItem<String>>(
                              (String value) {
                                var document = snapshot.data!.docs
                                    .firstWhere((doc) => doc['name'] == value);
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    children: [
                                      Image.network(
                                        document['imageURL'],
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 8),
                                      Text(value),
                                    ],
                                  ),
                                );
                              },
                            ).toList(),
                            hint: Text("Choose a Vegetable"),
                            onChanged: (String? value) {
                              setState(() {
                                _chosenVeggie = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Choose a Vegetable",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: weightController,
                            decoration: InputDecoration(
                              labelText: 'Enter weight (in kg)',
                            ),
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true), // Allows decimal input
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          var chosenDoc = snapshot.data!.docs.firstWhere(
                              (doc) => doc['name'] == _chosenVeggie);
                          int veggieValue = chosenDoc[
                              'value']; // Assuming value is stored in Firebase
                          double weight =
                              double.tryParse(weightController.text) ??
                                  0; // Parses weight as a double
                          _showBenefitDialog(weight, veggieValue);
                        },
                        child: Text('Calculate Benefit'),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
