import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BenefitHistoryPage extends StatefulWidget {
  const BenefitHistoryPage({Key? key}) : super(key: key);

  @override
  _BenefitHistoryPageState createState() => _BenefitHistoryPageState();
}

class _BenefitHistoryPageState extends State<BenefitHistoryPage> {
  late Future<DocumentSnapshot> benefits;

  @override
  void initState() {
    super.initState();
    benefits = getUserBenefits();
  }

  Future<DocumentSnapshot> getUserBenefits() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Benefit History'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: benefits,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            Map<dynamic, dynamic>? data =
                snapshot.data!.data() as Map<dynamic, dynamic>?;
            List<dynamic>? yourBenefits =
                data!['your_benefit'] as List<dynamic>?;

            Map<String, double> carbonmultipliers = {
              'onion': 0.1,
              'apple': 0.4,
              'bread': 1.3,
            };
            Map<String, double> watermultipliers = {
              'onion': 316,
              'apple': 822,
              'bread': 1608,
            };

            yourBenefits!.sort((a, b) =>
                (b['date'] as Timestamp).compareTo(a['date'] as Timestamp));

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text('Action'),
                  ),
                  DataColumn(
                    label: Text('Veggie'),
                  ),
                  DataColumn(
                    label: Text('Weight'),
                  ),
                  DataColumn(
                    label: Text('Date'),
                  ),
                  DataColumn(
                    label: Text('Carbon Emission (kg)'),
                  ),
                  DataColumn(
                    label: Text('Water Saved (liters)'),
                  ),
                ],
                rows: yourBenefits.map<DataRow>((benefit) {
                  String action = benefit['action'];
                  String veggie = benefit['veggie'];
                  double weight = (benefit['weight'] as num).toDouble();
                  DateTime timestampDate =
                      (benefit['date'] as Timestamp).toDate();

                  DateTime date = DateTime(
                      timestampDate.year,
                      timestampDate.month,
                      timestampDate.day,
                      timestampDate.hour,
                      timestampDate.minute);
                  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
                  String dateString = dateFormat.format(date);

                  double carbonmultiplier = carbonmultipliers[veggie] ?? 1.0;
                  double watermultiplier = watermultipliers[veggie] ?? 1.0;
                  double carbonSaved = double.parse(
                      (weight * carbonmultiplier).toStringAsFixed(2));
                  double waterSaved = double.parse(
                      (weight * watermultiplier).toStringAsFixed(2));

                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text(action)),
                      DataCell(Text(veggie)),
                      DataCell(Text('$weight kg')),
                      DataCell(Text(dateString)),
                      DataCell(Text(carbonSaved.toString())),
                      DataCell(Text(waterSaved.toString())),
                    ],
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
