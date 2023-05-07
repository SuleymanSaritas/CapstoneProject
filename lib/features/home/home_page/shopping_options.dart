import 'package:flutter/material.dart';
import '../../../../core/widget/gradient_container.dart';

class ShoppingOptions extends StatefulWidget {
  @override
  _ShoppingOptionsState createState() => _ShoppingOptionsState();
}

class _ShoppingOptionsState extends State<ShoppingOptions> {
  @override
  Widget build(BuildContext context) {
    return buildGradientContainer(
      GridView.count(
        physics: BouncingScrollPhysics(),
        primary: false,
        padding: const EdgeInsets.all(10),
        crossAxisSpacing: 11,
        mainAxisSpacing: 11,
        crossAxisCount: 3,
        children: <Widget>[],
      ),
    );
  }
}
