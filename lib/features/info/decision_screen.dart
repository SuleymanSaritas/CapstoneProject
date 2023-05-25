import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lego_market_app/features/info/donation_screen.dart';
import 'package:lego_market_app/features/info/recycle_solution_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../authenticate/auth_page/auth_type_selector.dart';
import '../add_product/add_product_screen.dart';
import 'compost_solution_screen.dart';
import 'cook_recipes_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
  int? _color, _smell, _texture;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    if (_auth.currentUser == null) {
      return AuthTypeSelector();
    }
    Map<String, Widget Function()> _solutionRoutes = {
      'Cook': () => CookRecipesPage(product: _chosenVeggie),
      'Donate': () => DonationPage(product: _chosenVeggie),
      'Sell': () => AddProductPage(),
      'Compost': () => CompostSolutionPage(product: _chosenVeggie),
      'Recycle': () => RecycleSolutionPage(product: _chosenVeggie),

      // Diğer çözümler ve sayfaları buraya ekleyin
    };
    return Scaffold(
      appBar: AppBar(
        title: Text('Best Solution For Your Product'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
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

          List<String> veggieList = (snapshot.data != null)
              ? snapshot.data!.docs
                  .map((document) => document['name'].toString())
                  .toList()
              : [];

          List<DropdownMenuItem<int>> scoreItems =
              List<DropdownMenuItem<int>>.generate(
            5,
            (index) => DropdownMenuItem<int>(
              value: index + 1,
              child: Container(
                margin:
                    EdgeInsets.only(left: screenWidth * 0.01), // left margin
                child: Text(
                  (index + 1).toString(),
                  style: TextStyle(
                    color: Colors.black, // Text color is white
                    fontWeight: FontWeight.bold, // Text is bold
                  ),
                ),
              ),
            ),
          );

          return ListView(
            children: <Widget>[
              Container(
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              margin:
                                  EdgeInsets.only(bottom: screenHeight * 0.01),
                              child: Text(
                                "Choose a Product",
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                              ))),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              border: Border.all(color: Colors.grey),
                              boxShadow: [BoxShadow(blurRadius: 2)],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton<String>(
                              value: _chosenVeggie,
                              items: veggieList.map<DropdownMenuItem<String>>(
                                (String value) {
                                  var document = snapshot.data!.docs.firstWhere(
                                      (doc) => doc['name'] == value);
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Row(
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: screenWidth * 0.01),
                                            child: Image.network(
                                              document['imageURL'],
                                              width: 24,
                                              height: 24,
                                              fit: BoxFit.cover,
                                            )),
                                        SizedBox(width: 8),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: screenWidth *
                                                  0.01), // Sol taraf boşluğu (1% ekran genişliği)
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight
                                                    .bold), // Metin kalın ve beyaz
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ).toList(),
                              hint: Container(
                                margin: EdgeInsets.only(
                                    left: screenWidth *
                                        0.02), // Sol taraf boşluğu (2% ekran genişliği)
                                child: Text("Choose a Product"),
                              ),
                              onChanged: (String? value) {
                                if (value != null) {
                                  setState(() {
                                    _chosenVeggie = value;
                                  });
                                }
                              },
                            ),
                          ))
                    ],
                  )),
              Container(
                margin: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.05), // margin eklendi
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                        child: Text(
                          "Color Score",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          border: Border.all(color: Colors.grey),
                          boxShadow: [BoxShadow(blurRadius: 2)],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton<int>(
                          value: _color,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          items: scoreItems,
                          hint: Container(
                            margin: EdgeInsets.only(
                                left: screenWidth * 0.02), // left margin
                            child: Text("Select Color Score"),
                          ),
                          onChanged: (int? value) {
                            setState(() {
                              _color = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.05), // margin eklendi
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                        child: Text(
                          "Smell Score",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          border: Border.all(color: Colors.grey),
                          boxShadow: [BoxShadow(blurRadius: 2)],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton<int>(
                          value: _smell,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          items: scoreItems,
                          hint: Container(
                            margin: EdgeInsets.only(
                                left: screenWidth * 0.02), // left margin
                            child: Text("Select Smell Score"),
                          ),
                          onChanged: (int? value) {
                            setState(() {
                              _smell = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.05), // margin eklendi
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                        child: Text(
                          "Texture Score",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          border: Border.all(color: Colors.grey),
                          boxShadow: [BoxShadow(blurRadius: 2)],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton<int>(
                          value: _texture,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          items: scoreItems,
                          hint: Container(
                            margin: EdgeInsets.only(
                                left: screenWidth * 0.02), // left margin
                            child: Text("Select Texture Score"),
                          ),
                          onChanged: (int? value) {
                            setState(() {
                              _texture = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  double totalScore = (_color! * 0.246153846 +
                      _smell! * 0.676923077 +
                      _texture! * 0.076923077);
                  DocumentSnapshot chosenVeggie = snapshot.data!.docs
                      .firstWhere(
                          (document) => document['name'] == _chosenVeggie);

                  List<String> solutions;
                  String condition = "";

                  if (totalScore < 2) {
                    solutions =
                        List<String>.from(chosenVeggie['good_solution']);
                    condition = "good";
                  } else if (totalScore < 3 && totalScore >= 2) {
                    solutions =
                        List<String>.from(chosenVeggie['semi_good_solution']);
                    condition = "semi good";
                  } else if (totalScore >= 3 && totalScore < 4) {
                    solutions = List<String>.from(chosenVeggie['bad_solution']);
                    condition = "bad";
                  } else {
                    solutions =
                        List<String>.from(chosenVeggie['rotten_solution']);
                    condition = "rotten";
                  }

                  if (_chosenVeggie != null) {
                    _solutionRoutes['Recycle'] =
                        () => RecycleSolutionPage(product: _chosenVeggie);
                    _solutionRoutes['Compost'] =
                        () => CompostSolutionPage(product: _chosenVeggie);
                    _solutionRoutes['Cook'] =
                        () => CookRecipesPage(product: _chosenVeggie);
                    _solutionRoutes['Donate'] =
                        () => DonationPage(product: _chosenVeggie);
                  }

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        title: Text('Solutions for $_chosenVeggie'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Your product is $condition . "),
                            ...solutions.map((solution) => ElevatedButton(
                                  onPressed: () {
                                    if (_solutionRoutes.containsKey(solution)) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                _solutionRoutes[solution]!()),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF8A2BE2),
                                  ),
                                  child: Text(solution),
                                ))
                          ],
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
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xFF8A2BE2), // Set button color to green
                  elevation: 5, // Add shadow
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Add rounded corners
                  ),
                ),
                child: Text('Get Solution'),
              ),
            ],
          );
        },
      ),
    );
  }
}
