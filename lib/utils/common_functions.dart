import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//screen size
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
//show toast
void showToast(String message) {
  Fluttertoast.showToast(
      msg: message, // message
      toastLength: Toast.LENGTH_SHORT, // length
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey // location
      // timeInSecForIos: 1               // duration
      );
}
//check for poor internet connectivity
  bool _connected = false;
Future<bool> checkInternetConnection() async {
 try {
    final response = await InternetAddress.lookup('www.google.com');
    if (response.isNotEmpty) {
      _connected = true;
    }
  } on SocketException {
    _connected = false;
  }

  if (_connected) {
    log("Internet connected");
  } else {
    showToast("No Internet Connection");
  }

  return _connected;
}
// show loader
showLoadingDialog(
  BuildContext context,
) {
  showDialog(
      context: context,
      builder: (_) => const CupertinoActivityIndicator(
          radius: 20, color: Colors.purple));
}