import 'package:flutter/material.dart';

class LabelText extends StatelessWidget {
  final String label;
  const LabelText({
    super.key,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    return  Center(child: Text(label, style: const TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),));
  }
}