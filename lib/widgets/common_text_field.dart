import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextField extends StatelessWidget {
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  const CommonTextField({
    super.key,
    this.keyboardType,
    this.inputFormatters,
   required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return  TextField(
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
           decoration:const InputDecoration(
            
             filled: true,
             fillColor: Colors.white, // White background
           border: OutlineInputBorder(
               borderRadius: BorderRadius.all(Radius.circular(7)), // Border radius of 30
               borderSide: BorderSide(color: Colors.black54), // No visible border
             ),
             contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Padding inside the search field
           ),
         );
  }
}

