import 'package:flutter/material.dart';

buildProfileData(
  Color color,
  double width,
  double height,
  AlignmentGeometry widgetAlignment,
  Widget widget,
) {
  return Padding(
    padding: EdgeInsets.all(7.0),
    child: Container(
      alignment: widgetAlignment,
      width: width,
      height: height,
      child: widget,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10), // Added for a softer look
      ),
    ),
  );
}
