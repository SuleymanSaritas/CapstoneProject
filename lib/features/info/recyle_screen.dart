import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VeggieListPage extends StatefulWidget {
  @override
  _VeggieListPageState createState() => _VeggieListPageState();
}

class _VeggieListPageState extends State<VeggieListPage> {
  final _veggiesCollection =
      FirebaseFirestore.instance.collection('veggie_waste_solutions');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to recycle your vegetables'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange[300],
        elevation: 0, // Matlık için gerekli
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _veggiesCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: Image.network(data['imageURL']),
                  title: Text(data['name']),
                  trailing: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Solution for ${data['name']}'),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: data['solution'] != null
                                  ? data['solution']
                                      .map<Widget>(
                                          (solution) => Text('• $solution'))
                                      .toList()
                                  : [],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Details'),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
