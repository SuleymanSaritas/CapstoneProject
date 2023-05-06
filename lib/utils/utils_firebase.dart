import 'package:flutter/material.dart';

class Utils {
  static void showSnackBar(
    BuildContext context, {
    @required String? text,
  }) {
    // ignore: deprecated_member_use
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text!)));
  }
}
