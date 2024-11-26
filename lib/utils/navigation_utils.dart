import 'package:flutter/material.dart';

void navigationPop(BuildContext context) async {
  Navigator.pop(context);
}

openScreen(BuildContext context, Widget screen) async {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}