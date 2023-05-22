import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lego_market_app/features/info/donation_screen.dart';
import 'package:lego_market_app/features/info/recycle_solution_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../authenticate/auth_page/auth_type_selector.dart';
import '../add_product/add_product_screen.dart';
import 'compost_solution_screen.dart';
import 'cook_recipes_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class VeggieListPage extends StatefulWidget {
  @override
  _VeggieListPageState createState() => _VeggieListPageState();
}

class _VeggieListPageState extends State<VeggieListPage> {
  late Stream<DocumentSnapshot> _usersStream;
  @override
  void initState() {
    super.initState();
    if (_auth.currentUser != null) {
      _usersStream = FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid.toString())
          .snapshots();
    }
  }

  final _veggiesCollection =
      FirebaseFirestore.instance.collection('veggie_waste_solutions');
  String? _chosenVeggie;
  int? _condition, _color, _smell, _texture;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser == null) {
      return AuthTypeSelector();
    }
    Map<String, Widget Function()> _solutionRoutes = {
      'Cook': () => CookRecipesPage(product: _chosenVeggie),
      'Donate': () => DonationPage(),
      'Sell': () => AddProductPage(),
      'Compost': () => CompostSolutionPage(product: _chosenVeggie),
      'Recycle': () => RecycleSolutionPage(product: _chosenVeggie),

      // Diğer çözümler ve sayfaları buraya ekleyin
    };
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Take Advantage'),
      //   centerTitle: true,
      //   backgroundColor: Colors.deepOrange[300],
      //   elevation: 0,
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _veggiesCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<String> veggieList = (snapshot.data != null)
              ? snapshot.data!.docs
                  .map((document) => document['name'].toString())
                  .toList()
              : [];

          List<DropdownMenuItem<int>> scoreItems =
              List<DropdownMenuItem<int>>.generate(
            9,
            (index) => DropdownMenuItem<int>(
              value: index + 1,
              child: Text((index + 1).toString()),
            ),
          );

          return ListView(
            children: <Widget>[
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
                      if (value != null) {
                        setState(() {
                          _chosenVeggie = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Condition Score",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<int>(
                    value: _condition,
                    items: scoreItems,
                    hint: Text("Condition Score"),
                    onChanged: (int? value) {
                      setState(() {
                        _condition = value;
                      });
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Color Score",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<int>(
                    value: _color,
                    items: scoreItems,
                    hint: Text("Color Score"),
                    onChanged: (int? value) {
                      setState(() {
                        _color = value;
                      });
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Smell Score",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<int>(
                    value: _smell,
                    items: scoreItems,
                    hint: Text("Smell Score"),
                    onChanged: (int? value) {
                      setState(() {
                        _smell = value;
                      });
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Texture Score",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<int>(
                    value: _texture,
                    items: scoreItems,
                    hint: Text("Select Texture Score"),
                    onChanged: (int? value) {
                      setState(() {
                        _texture = value;
                      });
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  int totalScore = _condition! + _color! + _smell! + _texture!;
                  DocumentSnapshot chosenVeggie = snapshot.data!.docs
                      .firstWhere(
                          (document) => document['name'] == _chosenVeggie);
                  List<String> solutions =
                      totalScore > chosenVeggie['threshold']
                          ? List<String>.from(chosenVeggie['best_option'])
                          : List<String>.from(chosenVeggie['worst_option']);
                  if (_solutionRoutes.containsKey('Recycle')) {
                    if (_chosenVeggie != null) {
                      _solutionRoutes['Recycle'] =
                          () => RecycleSolutionPage(product: _chosenVeggie);
                      _solutionRoutes['Compost'] =
                          () => CompostSolutionPage(product: _chosenVeggie);
                      _solutionRoutes['Cook'] =
                          () => CookRecipesPage(product: _chosenVeggie);
                    }
                  }

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Solutions for $_chosenVeggie'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: solutions
                              .map((solution) => ElevatedButton(
                                    onPressed: () {
                                      if (_solutionRoutes
                                          .containsKey(solution)) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  _solutionRoutes[solution]!()),
                                        );
                                      }
                                    },
                                    child: Text(solution),
                                  ))
                              .toList(),
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
                child: Text('Get Solution'),
              ),
            ],
          );
        },
      ),
    );
  }
}
